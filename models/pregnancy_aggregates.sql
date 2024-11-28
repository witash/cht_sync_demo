{{
  config(
    materialized = 'materialized_view',
    on_schema_change='append_new_columns',
  )
}}

SELECT
  count(*),
  chw.name as chw_name,
  health_center.name as health_center_name,
  district.name as district_name
FROM {{ ref('pregnancy') }}  preg
LEFT JOIN {{ ref('household') }} household ON household.uuid = preg.reported_by_parent
LEFT JOIN {{ ref('chw') }} chw ON chw.health_center = household.health_center
LEFT JOIN {{ ref('contact') }} health_center ON chw.health_center = health_center.uuid
LEFT JOIN {{ ref('contact') }} district ON health_center.parent_uuid = district.uuid
WHERE preg.danger_signs = 'yes'
group by chw.name, health_center.name, district.name
