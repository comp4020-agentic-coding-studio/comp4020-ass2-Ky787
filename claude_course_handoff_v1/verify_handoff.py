"""Read-only, offline integrity/navigation check; never execute any specimen.

Python 3.9+ standard library. Run from any working directory. Windows provenance
paths inside assets are deliberately not resolved on the receiving machine.
"""
from pathlib import Path, PurePosixPath
import hashlib
import json
import re
import struct
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


def read_json(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def verify(root=ROOT, require_checksums=True):
    root = root.resolve()
    errors = []
    checks = {}

    def check(condition, message):
        if not condition:
            errors.append(message)

    def local(rel):
        """Check exact Linux casing, independent of host filesystem behavior."""
        check('\\' not in rel and not re.match(r'^[A-Za-z]:', rel), 'Nonportable path: '+rel)
        p = PurePosixPath(rel)
        if p.is_absolute() or '..' in p.parts:
            errors.append('Out-of-package path: '+rel)
            return None
        path = root
        for part in p.parts:
            if not path.is_dir() or part not in {c.name for c in path.iterdir()}:
                errors.append('Missing or case-mismatched path: '+rel)
                return None
            path = path / part
            if path.is_symlink():
                errors.append('Symlink is not permitted: '+rel)
                return None
        if not path.is_file():
            errors.append('Not a file: '+rel)
            return None
        return path

    all_paths = sorted(p for p in root.rglob('*') if p.is_file())
    all_names = {p.relative_to(root).as_posix() for p in all_paths}
    check(len(all_names)==len({n.casefold() for n in all_names}), 'Case-colliding filenames')
    check(not any(p.is_symlink() for p in root.rglob('*')), 'Symlink found')
    forbidden = {'.pdb', '.map', '.html', '.htm', '.css', '.js', '.mjs', '.jsx', '.tsx', '.vue', '.svelte'}
    check(not any(p.suffix.lower() in forbidden for p in all_paths), 'Website/PDB/MAP file found')
    for p in all_paths:
        if p.suffix.lower()=='.json':
            try:
                read_json(p)
            except (ValueError, UnicodeError) as exc:
                errors.append('Invalid JSON '+str(p.relative_to(root))+': '+str(exc))
    manifest = read_json(root/'ASSET_MANIFEST.json')
    by_path = {r['curated_path']:r for r in manifest}
    check(len(by_path)==len(manifest), 'Duplicate asset-manifest path')
    check(set(by_path)=={n for n in all_names if n.startswith('assets/')}, 'Manifest asset coverage differs from files')
    for rel, row in by_path.items():
        for key in ['original_path', 'sha256', 'description', 'correctness_status', 'safe_to_execute']:
            check(bool(row.get(key)), 'Missing manifest field '+key+' for '+rel)
        p = local(rel)
        if p:
            check(sha(p)==row['sha256'].upper(), 'Asset SHA-256 mismatch: '+rel)
            check(p.stat().st_size==row['bytes'], 'Asset size mismatch: '+rel)
    checks['assets_hashed'] = len(manifest)

    bins = read_json(root/'BINARY_INDEX.json')
    check({b['path'] for b in bins}=={n for n in all_names if n.lower().endswith('.exe')}, 'Binary index coverage mismatch')
    for b in bins:
        rel = b['path']
        p = local(rel)
        if not p:
            continue
        check(b['sha256'].upper()==sha(p), 'Binary index hash mismatch: '+rel)
        check(b['correctness_status']==by_path[rel]['correctness_status'], 'Binary status mismatch: '+rel)
        check(b['safe_to_execute']==by_path[rel]['safe_to_execute'], 'Execution status mismatch: '+rel)
        data = p.read_bytes()
        nt = struct.unpack_from('<I', data, 0x3c)[0]
        check(data[:2]==b'MZ' and data[nt:nt+4]==b'PE\0\0', 'Invalid PE headers: '+rel)
        check(struct.unpack_from('<H', data, nt+4)[0]==0x8664, 'Not AMD64: '+rel)
        check(struct.unpack_from('<H', data, nt+24)[0]==0x20b, 'Not PE32+: '+rel)
        check('binprotect' not in rel.lower(), 'BinProtect executable bundled')
        if '/s05_polaris_fla_wrong/rewritten/' in rel:
            check('WRONG' in b['correctness_status'] and b['safe_to_execute'].startswith('NO'), 'Wrong Polaris PE not clearly rejected')
            check('INCORRECT_DEOBFUSCATION_DO_NOT_USE_AS_WORKING_BINARY' in p.name, 'Wrong PE filename warning missing')
        else:
            check(b['correctness_status'].startswith('PASS') and b['safe_to_execute'].startswith('YES'), 'Unexpected retained PE status: '+rel)
    checks['pe_x64_binaries'] = len(bins)
    for rel, row in by_path.items():
        if '/s01_ollvm_sub/mergen/' in rel:
            check('SEMANTIC FAILURE' in row['correctness_status'], 'Mergen negative artifact not labelled: '+rel)

    visuals = read_json(root/'VISUAL_INDEX.json')
    check({v['path'] for v in visuals}=={n for n in all_names if n.startswith('assets/ida/')}, 'Visual index coverage mismatch')
    for v in visuals:
        local(v['path'])
        for key in ['filename','story_number','topic','likely_comparison','target_function','visibly_demonstrates','recommended_use','classification','suggested_caption','confidence']:
            check(bool(v.get(key)), 'Missing visual field '+key+' in '+v['path'])
        if v.get('warning'):
            check('PUBLICATION HOLD' in by_path[v['path']]['correctness_status'], 'Visual hold missing from manifest')
    checks['screenshots_indexed'] = len(visuals)
    checks['screenshot_publication_holds'] = sum(bool(v.get('warning')) for v in visuals)
    lecture = read_json(root/'assets/tables/lecture/tables.json')['tables']
    for table in lecture:
        for ext in ['svg','png']:
            local('assets/tables/lecture/'+ext+'/'+table['id']+'.'+ext)
    checks['lecture_tables_indexed'] = len(lecture)
    checks['cfg_visuals'] = sum(n.startswith('assets/cfg/') and n.endswith('.svg') for n in all_names)

    topics = read_json(root/'TOPIC_INDEX.json')
    for t in topics:
        for key in ['source','binary','clean','rewrite','ir','cfg','screenshot','table','report']:
            if t.get(key):
                local(t[key])
    checks['topic_mappings_checked'] = len(topics)
    archival = read_json(root/'ARCHIVAL_REPORT_LINKS.json')
    for a in archival:
        local(a['report'])
        if a['bundled_path']:
            local(a['bundled_path'])
    checks['archival_links_catalogued'] = len(archival)
    checks['archival_links_to_bundled_assets'] = sum(bool(a['bundled_path']) for a in archival)
    checks['archival_links_intentionally_unbundled'] = sum(not a['bundled_path'] for a in archival)

    links = 0
    for md in sorted(root.glob('*.md')):
        content = md.read_text(encoding='utf-8')
        for match in re.finditer(r'\[[^\]]*\]\(([^)]+)\)', content):
            href = match.group(1).strip('<>')
            if re.match(r'^(https?://|mailto:)', href):
                continue
            plain = unquote(href.split('#')[0])
            if plain:
                local(plain)
                links += 1
    checks['primary_markdown_local_links_checked'] = links
    # Copied Markdown stays byte-exact; its historical paths are catalogued above.
    required = ['COURSE_BRIEF','PROVISIONAL_12_WEEK_OUTLINE','VISUAL_INDEX','BEST_EVIDENCE_BY_TOPIC',
                'CLAIMS_AND_CAVEATS','TERMINOLOGY','EXPERIMENTAL_CORPUS','TOOL_CATALOG',
                'EXPERIMENT_TIMELINE','ASSESSMENT_IDEAS','HANDS_ON_LABS','BIBLIOGRAPHY',
                'LECTURE_TABLE_INDEX','HANDOFF_ASSET_MAP','CLAUDE_SITE_BUILDER_HANDOFF','HANDOFF_README']
    for name in required:
        local(name+'.md')
    outline = (root/'PROVISIONAL_12_WEEK_OUTLINE.md').read_text(encoding='utf-8')
    for week in range(1,13):
        check(bool(re.search(r'^## Week '+str(week)+r' —', outline, re.M)), 'Missing outline week '+str(week))
    for marker in ['**Objective:**','**Subtopics:**','**Best evidence:**','**Best table:**','**Best screenshot:**','**Activity:**','**Prerequisites:**']:
        check(outline.count(marker)==12, 'Weekly outline field count: '+marker)
    checks['provisional_weeks'] = 12
    # Prevent the prior high-level targeting mistake from returning in these copies.
    obfuscators = (root/'assets/tables/research/obfuscators.md').read_text(encoding='utf-8-sig')
    overview = (root/'assets/reports/FINAL_RESEARCH_OVERVIEW.md').read_text(encoding='utf-8-sig')
    check('Function annotations in validated lane' not in obfuscators, 'Old Hikari targeting wording present')
    for label, body in [('obfuscators table',obfuscators),('overview',overview)]:
        check('Hikari' in body and 'global' in body and 'annotation' in body, 'Missing targeting qualification in '+label)
    check(sha(root/'assets/source/showcase.c')=='39FEF0BB2A9742870F3D6F7CC864F7CFFA129136F6D2A59C4FB37F25906B99D2', 'Frozen showcase hash')
    check(sha(root/'assets/source/substitution_complex.c')=='026AA69530C711ACC856C62A21852ABC0F536D7784717C9EBDC48252BCA47F37', 'Frozen complex-probe hash')

    sums = root/'SHA256SUMS.txt'
    if require_checksums:
        check(sums.is_file(), 'Missing SHA256SUMS.txt')
        if sums.is_file():
            expected = {}
            for line in sums.read_text(encoding='utf-8').splitlines():
                digest, rel = line.split('  ',1)
                check(rel not in expected, 'Duplicate checksum path: '+rel)
                expected[rel] = digest.upper()
                p = local(rel)
                if p:
                    check(sha(p)==digest.upper(), 'Package SHA-256 mismatch: '+rel)
            check(set(expected)==all_names-{'SHA256SUMS.txt'}, 'Checksum coverage differs from package files')
            checks['package_files_hashed'] = len(expected)
    checks['package_files'] = len(all_paths)
    checks['package_bytes'] = sum(p.stat().st_size for p in all_paths)
    checks['asset_bytes'] = sum(r['bytes'] for r in manifest)
    return {'status':'PASS' if not errors else 'FAIL', 'checks':checks, 'errors':errors}


if __name__=='__main__':
    result = verify()
    print(json.dumps(result, ensure_ascii=False, indent=2))
    raise SystemExit(0 if result['status']=='PASS' else 1)
