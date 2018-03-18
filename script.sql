SET serveroutput ON

PROMPT "Start of control"
/

@drop-scripts/drop-sequences.sql
@drop-scripts/drop-tables.sql
@sequences.sql
@relationships.sql
@triggers.sql
/

PROMPT "End of control"
/