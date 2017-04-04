SELECT m.act_kind, pm.population,
count(DISTINCT pm.member_id) AS member_count,
count(distinct m.act_id || m.member_id) AS sends,
count(distinct t.uuid || t.member_id) as opens
--count(distinct r.rsvp_id) as Mems_driven_RSVP
FROM population_member pm
JOIN device_message m ON pm.member_id = m.member_id
AND m.date >= '2016-03-01'
AND m.date < '2016-03-11'
left join tap t on t.uuid || t.member_id = m.act_id || m.member_id -- try as independent join
AND t.date >= '2016-03-01'
AND t.date <'2016-03-11'
and t.source in ('os', 'os_action', 'os_stacked') --excluding in-app opens
--left join rsvp_yes_action r on r.member_id = pm.member_id and datediff(hour, m.created_at, r.created_at) <= 1 and datediff(hour, m.created_at, r.created_at) >= 0 and r.rsvp_code > 2 --m for send time, t for open time
where pm.active = 'true' 
and pm.pushable = 'true' 
--and pm.population in (9,10)
and pm.member_id > 0
--and m.carrier = 'gcm' --removing to get an accurate count of push notifs. sent
GROUP BY m.act_kind, pm.population;