{% set custom_fields %}
  contact.uuid as chw_id
{% endset %}
{{ cht_contact_model('chw', [
  {'id': 'health_center', 'table': 'contact'},
  {'id': 'district_hospital', 'table': 'contact'}
], custom_fields) }}

