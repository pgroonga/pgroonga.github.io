---
title: "pgroonga.force_match_escalation parameter"
upper_level: ../
---

# `pgroonga.force_match_escalation` parameter

Since 2.2.8.

## Summary

`pgroonga.force_match_escalation` parameter controls whether match escalation is always used or not.

Match escalation is auto loose search. If this parameter is `on`, match escalation is always used.

The default is `off`. It means that match escalation is used conditionally.

You can always use match escalation by specifying `on`.

Normally, you don't need to change this parameter. Conditional match escalation is suitable for users.

See also [`pgroonga.match_escalation_threshold` parameter][match-escalation-threshold].

## Syntax

In SQL:

```sql
SET pgroonga.force_match_escalation = boolean;
```

In `postgresql.conf`:

```text
pgroonga.force_match_escalation = boolean
```

`boolean` is a boolean value. There are some literals for boolean value such as `on`, `off`, `true`, `false`, `yes` and `no`.

## Usage

Here is an example SQL to always use match escalation:

```sql
SET pgroonga.force_match_escalation = on;
```

Here is an example configuration to always use match escalation:

```sql
pgroonga.force_match_escalation = on
```

## See also

  * [`pgroonga.match_escalation_threshold` parameter][match-escalation-threshold]

[match-escalation-threshold]:match-escalation-threshold.html
