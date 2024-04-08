WITH data AS (
    SELECT
        cast(u.registered_params as jsonb) ->> 'source' as src,
        p.user_id as pid,
        p.income,
        p.created_at::date as day,
        p.amount
    FROM
        payment_logs p
            JOIN users u ON u.id = p.user_id
            JOIN sources s on s.name=cast(u.registered_params as jsonb) ->> 'source'
            JOIN partners pp on pp.id=s.partner_id
    WHERE p.offer_id = 6
      AND p.status = TRUE
      AND pp.id =  34773
),
     source_names AS (
         SELECT id, name FROM sources WHERE offer_id = 6
     ),
     registered_by_source AS (
         SELECT
             u.created_at::date AS day,
             COUNT(u.id) as cnt,
             cast(u.registered_params as jsonb) ->> 'source' as src
         FROM users u
                  JOIN sources s on s.name=cast(u.registered_params as jsonb) ->> 'source'
                  JOIN partners pp on pp.id=s.partner_id
         WHERE u.offer_id = 6 AND cast(u.registered_params as jsonb) ->> 'source' IN (SELECT name FROM source_names)
         GROUP BY day, src
     ),
     subscribed_by_source AS (
         SELECT
             p.created_at::date AS day,
             COUNT(p.id) as cnt,
             cast(u.registered_params as jsonb) ->> 'source' as src
         FROM payment_logs p
                  JOIN users u on u.id=p.user_id
         WHERE p.offer_id = 6
           AND p.status = true
           AND (p.amount = 1 OR p.amount = 20 OR p.amount = 99 OR p.amount = 100 OR p.amount = 499)
         GROUP BY day, src
     )
SELECT
    d.day,
    rbs.cnt as registered,
    sbs.cnt as subscribed,
    COALESCE(sbs.cnt * 100.0 / rbs.cnt, 0) AS cr,
    count(d.income) as trx,
    sum(d.income)/2 as total_income
FROM data d
         LEFT JOIN registered_by_source as rbs ON rbs.day = d.day AND rbs.src = d.src
         LEFT JOIN subscribed_by_source as sbs ON sbs.day = d.day AND sbs.src = d.src
         LEFT JOIN source_names as n ON n.name = d.src
group by d.day, registered, subscribed
order by day desc, total_income desc;
