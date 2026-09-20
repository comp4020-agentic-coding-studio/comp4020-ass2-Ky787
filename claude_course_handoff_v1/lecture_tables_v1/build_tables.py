"""Render concise lecture inserts from retained evidence. No experiments run."""
from pathlib import Path
import hashlib
import html
import json
import math
import subprocess
import xml.etree.ElementTree as ET

from PIL import Image
from pypdf import PdfReader
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.colors import HexColor
from reportlab.lib.pagesizes import A4, landscape

HERE = Path(__file__).resolve().parent
PACK = HERE.parent / 'evidence_pack_v1'
ROOT = HERE.parent.parent
RUNTIME = Path(r'C:\Users\royga\.cache\codex-runtimes\codex-primary-runtime\dependencies')
POPPLER = RUNTIME / 'native/poppler/Library/bin/pdftoppm.exe'
PDF_DIR = HERE / 'output/pdf'
SVG_DIR = HERE / 'svg'
PNG_DIR = HERE / 'png'
QA_DIR = HERE / 'tmp/pdfs'
for folder in [PDF_DIR, SVG_DIR, PNG_DIR, QA_DIR]:
    folder.mkdir(parents=True, exist_ok=True)

pdfmetrics.registerFont(TTFont('Arial', r'C:\Windows\Fonts\arial.ttf'))
pdfmetrics.registerFont(TTFont('Arial-Bold', r'C:\Windows\Fonts\arialbd.ttf'))
DATA = json.loads((HERE / 'tables.json').read_text(encoding='utf-8'))
W, M = 1180, 40
CW = W - 2 * M
INK, MUTED, NAVY, BORDER = '#172C3D', '#546776', '#183B50', '#D9E2E8'
TONES = {
    'pass': ('#E3F3EB', '#15533A'),
    'partial': ('#FFF0D5', '#744700'),
    'fail': ('#FCE5E8', '#922838'),
    'info': ('#E7F0FA', '#224F78'),
    'neutral': ('#EEF1F4', '#465462'),
}
FONT, LINE = 18.5, 23
OPS = []

def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest().upper()

def walk_files(folder):
    return sorted(p for p in folder.rglob('*') if p.is_file())

# Freeze the existing pack for this presentation-only task, not just copied sources.
before = {str(p.relative_to(PACK)): digest(p) for p in walk_files(PACK)}
source_records = {}
for table in DATA['tables']:
    assert abs(sum(table['widths']) - 1) < 0.00001
    assert len(table['widths']) == len(table['columns'])
    for row in table['rows']:
        assert len(row) == len(table['columns'])
    for ref in table['sources']:
        p = PACK / ref
        assert p.is_file(), ref
        source_records[ref] = {'absolute_path': str(p), 'sha256': digest(p)}

def width(text, font='Arial', size=FONT):
    return pdfmetrics.stringWidth(text, font, size)

def wrap(text, max_width, font='Arial', size=FONT):
    """Word wrapping uses the exact embedded PDF font metrics."""
    result = []
    for paragraph in text.split('\n'):
        line = ''
        for word in paragraph.split():
            if width(word, font, size) > max_width:
                raise ValueError(f'Unbreakable label too wide: {word}')
            candidate = (line + ' ' + word).strip()
            if line and width(candidate, font, size) > max_width:
                result.append(line)
                line = word
            else:
                line = candidate
        result.append(line)
    return result

def rect(x, y, w, h, fill, radius=0):
    OPS.append(('rect', x, y, w, h, fill, radius))

def text(x, baseline, value, size=FONT, color=INK, bold=False):
    assert x >= 0 and x + width(value, 'Arial-Bold' if bold else 'Arial', size) <= W + 0.01, value
    OPS.append(('text', x, baseline, value, size, color, bold))

def line(x1, y1, x2, y2, color=BORDER):
    OPS.append(('line', x1, y1, x2, y2, color))

def para(value, x, y, max_width, size=FONT, leading=LINE, color=INK, bold=False):
    lines = wrap(value, max_width, 'Arial-Bold' if bold else 'Arial', size)
    for i, value in enumerate(lines):
        text(x, y + size + i * leading, value, size, color, bold)
    return len(lines) * leading

def cell_lines(value, max_width, is_label=False):
    obj = value if isinstance(value, dict) else {'text': value}
    tone = obj.get('tone')
    result = []
    for i, paragraph in enumerate(obj['text'].split('\n')):
        bold = is_label or (tone is not None and i == 0)
        for part in wrap(paragraph, max_width, 'Arial-Bold' if bold else 'Arial'):
            result.append((part, bold))
    return result, tone

def layout(table, index):
    OPS.clear()
    text(M, 31, f'SEEING THROUGH OBFUSCATION  /  TABLE {index:02}', 12.5, MUTED, True)
    text(M, 80, table['title'], 34, NAVY, True)
    y = 101
    y += para(table['subtitle'], M, y, CW, 18, 24, MUTED)
    y += 24
    widths = [w * CW for w in table['widths']]
    headers = [wrap(h, w - 24, 'Arial-Bold', 17) for h, w in zip(table['columns'], widths)]
    hh = max(map(len, headers)) * 22 + 24
    rect(M, y, CW, hh, NAVY)
    x = M
    for cell, w in zip(headers, widths):
        for j, label in enumerate(cell):
            text(x + 12, y + 28 + j * 22, label, 17, '#FFFFFF', True)
        x += w
    y += hh
    body_start = y
    rows = []
    for ri, row in enumerate(table['rows']):
        cells = [cell_lines(v, w - 28, ci == 0) for ci, (v, w) in enumerate(zip(row, widths))]
        rh = max(52, max(len(ls) for ls, _ in cells) * LINE + 24)
        x = M
        rect(M, y, CW, rh, '#FFFFFF' if ri % 2 == 0 else '#F5F8FA')
        for ci, ((lines_, tone), w) in enumerate(zip(cells, widths)):
            fill, fg = TONES[tone] if tone else ('#ECF2F5' if ci == 0 else None, INK)
            if fill:
                rect(x, y, w, rh, fill)
            text_y = y + (rh - len(lines_) * LINE) / 2 + FONT
            for j, (part, bold) in enumerate(lines_):
                text(x + 14, text_y + j * LINE, part, FONT, fg, bold)
            x += w
        line(M, y + rh, M + CW, y + rh)
        rows.append({'y': y, 'height': rh, 'line_counts': [len(ls) for ls, _ in cells]})
        y += rh
    # Very light column separators provide alignment without a heavy grid.
    x = M
    for w in widths[:-1]:
        x += w
        line(x, body_start, x, y, '#E0E7EC')
    y += 22
    takeaway_lines = wrap(table['takeaway'], CW - 38, 'Arial-Bold', 18)
    th = len(takeaway_lines) * 23 + 28
    rect(M, y, CW, th, '#E8F2F6', 5)
    for j, value in enumerate(takeaway_lines):
        text(M + 19, y + 31 + j * 23, value, 18, NAVY, True)
    y += th + 16
    y += para(table['note'], M, y, CW, 13.5, 18, MUTED)
    y += 13
    # Every coloured status also has an explicit text label in its table cell.
    legends = [('pass','Validated'),('partial','Qualified / incomplete'),('fail','Wrong / invalid'),('info','Observation'),('neutral','Not produced')]
    x = M
    for tone, label in legends:
        bg, fg = TONES[tone]
        rect(x, y + 1, 12, 12, bg)
        text(x + 18, y + 12, label, 12.5, fg)
        x += 18 + width(label, size=12.5) + 25
    y += 32
    text(M, y, 'Windows x64 | Retained samples only | Source keys in SOURCES.md', 12, MUTED)
    H = y + 24
    return list(OPS), H, rows

def svg_write(p, ops, h, table):
    elements = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{h}" viewBox="0 0 {W} {h}" role="img" aria-labelledby="title desc">',
                f'<title id="title">{html.escape(table["title"])}</title>',
                f'<desc id="desc">{html.escape(table["subtitle"] + " " + table["takeaway"])}</desc>',
                f'<rect width="{W}" height="{h}" fill="white"/>']
    for op in ops:
        if op[0] == 'rect':
            _, x,y,w,hh,fill,r = op
            elements.append(f'<rect x="{x:g}" y="{y:g}" width="{w:g}" height="{hh:g}" fill="{fill}" rx="{r}"/>')
        elif op[0] == 'text':
            _, x,y,value,size,color,bold = op
            elements.append(f'<text x="{x:g}" y="{y:g}" fill="{color}" font-family="Arial, Helvetica, sans-serif" font-size="{size}" font-weight="{700 if bold else 400}">{html.escape(value)}</text>')
        else:
            _, x1,y1,x2,y2,color = op
            elements.append(f'<line x1="{x1:g}" y1="{y1:g}" x2="{x2:g}" y2="{y2:g}" stroke="{color}" stroke-width="1"/>')
    elements.append('</svg>')
    p.write_text('\n'.join(elements)+'\n', encoding='utf-8')
    ET.parse(p)

def draw_pdf(c, ops, h):
    for op in ops:
        if op[0] == 'rect':
            _, x,y,w,hh,fill,r = op
            c.setFillColor(HexColor(fill))
            c.roundRect(x, h-y-hh, w, hh, r, stroke=0, fill=1)
        elif op[0] == 'text':
            _, x,y,value,size,color,bold = op
            c.setFillColor(HexColor(color))
            c.setFont('Arial-Bold' if bold else 'Arial', size)
            c.drawString(x, h-y, value)
        else:
            _, x1,y1,x2,y2,color = op
            c.setStrokeColor(HexColor(color))
            c.setLineWidth(1)
            c.line(x1, h-y1, x2, h-y2)

pdf_path = PDF_DIR / 'lecture_tables.pdf'
page_w, page_h = landscape(A4)
c = canvas.Canvas(str(pdf_path), pagesize=(page_w,page_h), pageCompression=1, invariant=1)
c.setTitle('Seeing Through Obfuscation - Concise Lecture Tables')
c.setAuthor('Seeing Through Obfuscation')
c.setSubject('Reusable tables from the retained Windows x64 research evidence')
layouts = []
for i, table in enumerate(DATA['tables'],1):
    ops, h, rows = layout(table, i)
    svg_write(SVG_DIR / (table['id']+'.svg'), ops, h, table)
    scale = min((page_w-32)/W, (page_h-32)/h)
    assert scale*FONT >= 10.8, (table['id'], scale*FONT, h)
    x, y = (page_w-W*scale)/2, (page_h-h*scale)/2
    c.saveState()
    c.translate(x,y)
    c.scale(scale,scale)
    draw_pdf(c,ops,h)
    c.restoreState()
    c.showPage()
    layouts.append({'id':table['id'], 'width':W, 'height':h, 'pdf_body_font_pt':scale*FONT,
                    'pdf_crop_pt':[x,y,W*scale,h*scale], 'rows':rows})
c.save()

reader = PdfReader(pdf_path)
assert len(reader.pages) == len(DATA['tables']) == 12
for p, table in zip(reader.pages,DATA['tables']):
    extracted = p.extract_text()
    assert table['title'] in extracted
    for row in table['rows']:
        for item in row:
            value = item['text'] if isinstance(item,dict) else item
            # Compare whitespace-normalized strings because PDF lines are wrapped.
            assert ' '.join(value.split()) in ' '.join(extracted.split()), (table['id'],value)

# Render all final PDF pages with Poppler, then crop the exact figure region for reuse.
subprocess.run([str(POPPLER), '-r','180','-png', str(pdf_path), str(QA_DIR/'page')], check=True)
for i, layout_ in enumerate(layouts,1):
    src = QA_DIR / f'page-{i:02}.png'
    if not src.exists():
        src = QA_DIR / f'page-{i}.png'
    img = Image.open(src).convert('RGB')
    sx, sy = img.width/page_w, img.height/page_h
    x,y,w,h = layout_['pdf_crop_pt']
    box = (max(0,math.floor(x*sx)), max(0,math.floor((page_h-y-h)*sy)),
           min(img.width,math.ceil((x+w)*sx)), min(img.height,math.ceil((page_h-y)*sy)))
    crop = img.crop(box)
    crop.save(PNG_DIR/(layout_['id']+'.png'), dpi=(180,180), optimize=True)

def cell_html(item):
    obj = item if isinstance(item,dict) else {'text':item}
    cls = obj.get('tone','')
    return f'<td class="{cls}">'+html.escape(obj['text']).replace('\n','<br>')+'</td>'

sections = []
for i,table in enumerate(DATA['tables'],1):
    header=''.join(f'<th scope="col">{html.escape(v)}</th>' for v in table['columns'])
    rows=''.join('<tr>'+''.join(cell_html(v) for v in row)+'</tr>' for row in table['rows'])
    cols=''.join(f'<col style="width:{w*100}%">' for w in table['widths'])
    links=' | '.join(f'<a href="../evidence_pack_v1/{html.escape(s)}">{html.escape(s)}</a>' for s in table['sources'])
    sections.append(f'''<section id="{table['id']}">
<p class="eyebrow">TABLE {i:02}</p><h2>{html.escape(table['title'])}</h2>
<p class="subtitle">{html.escape(table['subtitle'])}</p>
<div class="table-scroll"><table><colgroup>{cols}</colgroup><thead><tr>{header}</tr></thead><tbody>{rows}</tbody></table></div>
<p class="takeaway">{html.escape(table['takeaway'])}</p><p class="note">{html.escape(table['note'])}</p>
<p class="assets"><a href="svg/{table['id']}.svg">Vector SVG</a> / <a href="png/{table['id']}.png">High-resolution PNG</a></p>
<details><summary>Evidence sources</summary><p>{links}</p></details></section>''')
css = '''*{box-sizing:border-box}body{margin:0;background:#eef3f6;color:#172c3d;font:17px/1.45 Arial,Helvetica,sans-serif}main{max-width:1220px;margin:auto;padding:40px 24px}header{padding:16px 0 28px}h1{font-size:36px;line-height:1.12;margin:0 0 14px}h2{font-size:28px;line-height:1.2;margin:0 0 12px}.intro{max-width:800px;color:#546776}a{color:#1c5776;text-underline-offset:3px}nav{display:flex;gap:10px 22px;flex-wrap:wrap;margin:20px 0}.legend{display:flex;gap:8px 20px;flex-wrap:wrap;font-size:14px}.legend span{padding:5px 9px}section{background:#fff;padding:32px;margin:0 0 32px;border:1px solid #d9e2e8;border-radius:8px}.eyebrow{font-size:12px;letter-spacing:1.5px;font-weight:700;color:#546776;margin:0 0 10px}.subtitle{color:#546776;margin:0 0 22px}table{width:100%;border-collapse:collapse;table-layout:fixed}th{text-align:left;background:#183b50;color:white;padding:14px 12px;font-size:16px}td{padding:13px 12px;border-bottom:1px solid #d9e2e8;vertical-align:middle;overflow-wrap:anywhere}tbody tr:nth-child(even){background:#f5f8fa}td:first-child{background:#ecf2f5;font-weight:700}.pass{background:#e3f3eb;color:#15533a}.partial{background:#fff0d5;color:#744700}.fail{background:#fce5e8;color:#922838}.info{background:#e7f0fa;color:#224f78}.neutral{background:#eef1f4;color:#465462}.takeaway{background:#e8f2f6;font-weight:700;padding:15px 18px;margin:22px 0 12px;border-radius:5px}.note,details,.assets{font-size:14px;color:#546776}.assets{margin-bottom:6px}.table-scroll{overflow-x:auto}@media(max-width:650px){main{padding:20px 10px}section{padding:18px 12px}h1{font-size:29px}h2{font-size:24px}table{min-width:760px}}@media print{@page{size:A4 landscape;margin:10mm}body{background:white;font-size:11pt}main{padding:0}header,nav,details,.assets{display:none}section{padding:0;border:0;border-radius:0;margin:0;break-after:page}h2{font-size:21pt}td,th{padding:7px 9px}th{font-size:10.5pt}.eyebrow{font-size:8pt}.note{font-size:9pt}*{print-color-adjust:exact;-webkit-print-color-adjust:exact}}'''
page='''<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Seeing Through Obfuscation - lecture tables</title><style>'''+css+'''</style></head><body><main><header><p class="eyebrow">SEEING THROUGH OBFUSCATION</p><h1>Concise tables for lecture notes</h1><p class="intro">Twelve reusable tables. Each colour-coded result also has a text label. These are sample-specific research findings, not universal tool ratings.</p><p><a href="output/pdf/lecture_tables.pdf">Open the 12-page PDF</a> &nbsp; / &nbsp; <a href="README.md">Reuse guide</a></p><div class="legend"><span class="pass">Validated</span><span class="partial">Qualified / incomplete</span><span class="fail">Wrong / invalid</span><span class="info">Observation</span><span class="neutral">Not produced</span></div><nav>'''+''.join(f'<a href="#{t["id"]}">{i:02}</a>' for i,t in enumerate(DATA['tables'],1))+'''</nav></header>'''+''.join(sections)+'''</main></body></html>'''
(HERE/'index.html').write_text(page, encoding='utf-8')

sources_md=['# Evidence sources', '', 'Each table is an authored condensation, not a new experiment. Source files below are in the unchanged evidence_pack_v1 companion directory. Exact SHA-256 values are in SOURCES.json.', '']
for table in DATA['tables']:
    sources_md += ['## '+table['id'], '', table['title'], '']
    sources_md += [f'- [{s}](../evidence_pack_v1/{s})' for s in table['sources']]
    sources_md += ['']
(HERE/'SOURCES.md').write_text('\n'.join(sources_md), encoding='utf-8')
(HERE/'SOURCES.json').write_text(json.dumps({'evidence_pack':str(PACK),'sources':source_records,'table_sources':{t['id']:t['sources'] for t in DATA['tables']}},indent=2)+'\n',encoding='utf-8')

after = {str(p.relative_to(PACK)):digest(p) for p in walk_files(PACK)}
assert before == after, 'Existing evidence pack changed'
qa={'tables':12,'pdf_pages':12,'svg_files':12,'png_files':12,'pdf_text_checks':'all cells present',
    'layout_checks':'font-metric wrapped; no horizontal overflow; body size >= 10.8 pt in PDF',
    'existing_pack_files_checked':len(before),'existing_pack_unchanged':True,'new_experiments':0,
    'layouts':layouts,'visual_review':'Pending final review of every rendered page'}
(HERE/'QA.json').write_text(json.dumps(qa,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'pdf':str(pdf_path),'pages':12,'tables':12,'minimum_pdf_body_font_pt':min(x['pdf_body_font_pt'] for x in layouts),'unchanged_evidence_files':len(before),'pngs':[str(PNG_DIR/(t['id']+'.png')) for t in DATA['tables']]},indent=2))
