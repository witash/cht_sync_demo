{% set custom_fields %}
  couchdb.doc->>'patient_id' as patient_id
{% endset %}
{{ cht_contact_model('patient_person', [{'id': 'household', 'table': 'household'}], custom_fields) }}
