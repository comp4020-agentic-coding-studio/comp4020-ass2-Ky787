---
title: Dr Petra Kovač
description:
  Guest lecturer for Block IV. Audits other people's deobfuscation results for
  a living, which is a job that exists because valid output is not correct
  output.
affiliation: Visiting, from industry
role: guest
contact:
  Visits in weeks 10 and 12. Questions during those studios, or through the
  convenor between them.
---

Works on the receiving end of this field: given a rewritten binary and a claim
about it, decide whether the claim is true. Joins Block IV to take the course's
two negative results apart in front of you, and to argue that neither is a
tooling accident.

The week 10 argument is that the incorrect unflattening is a *semantic* bug
with a structural cause — four legitimate switch alternatives grouped under one
incoming state, then emitted in sequence — and that no amount of looking at the
graph would have caught it. The week 12 argument is the uncomfortable one: the
methods that transferred between implementations here are the ones that carried
an explicit model of state and a separate validation step, and the methods that
did not transfer were the ones that recognised a shape.

Also the reason the capstone asks what you could not establish. In practice
that section is the one that gets read first.
