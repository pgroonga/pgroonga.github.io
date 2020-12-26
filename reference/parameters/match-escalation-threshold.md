---
title: "pgroonga.match_escalation_threshold parameter"
upper_level: ../
---

# `pgroonga.match_escalation_threshold` parameter

## Summary

`pgroonga.match_escalation_threshold` parameter controls when match escalation is occurred.

Match escalation is auto loose search. If the number of matched records is equal or less than the threshold specified by `pgroonga.match_escalation_threshold` parameter, loose search is done automatically. It's match escalation.

The default threshold is `0`. It means that no records are matched, loose search is done automatically.

You can disable match escalation by specifying `-1`.

Normally, you don't need to change this parameter. Auto loose search is useful for users.

See also [`pgroonga.force_match_escalation` parameter][force-match-escalation].

## Syntax

In SQL:

```sql
SET pgroonga.match_escalation_threshold = threshold;
```

In `postgresql.conf`:

```text
pgroonga.match_escalation_threshold = threshold
```

`threshold` is a number value.

## Usage

Here is an example to disable match escalation:

```sql
SET pgroonga.match_escalation_threshold = -1;
```

## See also

  * [`pgroonga.force_match_escalation` parameter][force-match-escalation]

[force-match-escalation]:force-match-escalation.html
