{% set custom_fields %}
  contact.name AS household_name,
  couchdb.doc->>'place_id' AS household_contact_id
{% endset %}
{{ cht_contact_model('household', [{'id': 'health_center', 'table': 'contact'}], custom_fields) }}

