-- add any indexes specific to this form
-- depends_on: {{ ref('data_record') }}

{%- set form_indexes = [
  {'columns': ['edd']},
  {'columns': ['danger_signs']},
  {'columns': ['risk_factors']},
  {'columns': ['patient_id']}]
-%}
-- add columns specific to this form
{% set form_columns %}
  couchdb.doc->'fields' ->> 'patient_id' as patient_id,

  NULLIF(couchdb.doc->'fields'->>'lmp_date','')::date as lmp, -- CAST lmp string to date or NULL if empty
  NULLIF(couchdb.doc->'fields' ->> 'edd','')::date as edd, -- CAST edd string to date or NULL if empty

  couchdb.doc->'fields' ->> 'lmp_method' as lmp_method,
  couchdb.doc->'fields' ->> 'danger_signs' AS danger_signs,
  couchdb.doc->'fields' ->> 'risk_factors' AS risk_factors,

  -- extract the ANC visit number
  CASE
    WHEN couchdb.doc->'fields' ->>'anc_visit_identifier' <> ''
      THEN (couchdb.doc->'fields' ->>'anc_visit_identifier')::int
    WHEN couchdb.doc->'fields' #>>'{group_repeat,anc_visit_repeat,anc_visit_identifier}' <> ''
      THEN RIGHT(couchdb.doc->'fields' #>>'{group_repeat,anc_visit_repeat,anc_visit_identifier}'::text[], 1)::int
    ELSE 0 -- if not included default to 0
  END AS anc_visit
{% endset %}

-- call the macro with the form name, the columns and indexes to create the actual model
{{ cht_form_model('pregnancy', form_columns, form_indexes) }}
