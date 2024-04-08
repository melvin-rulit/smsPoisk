WITH data AS (
    SELECT
        p.user_id as pid,
        p.income
    FROM payment_logs p
             JOIN users u ON u.id = p.user_id
             JOIN sources s on s.name=cast(u.registered_params as jsonb) ->> 'source'
             JOIN partners pp on pp.id=s.partner_id
    WHERE p.status = TRUE
      AND pp.id =  17
),
     payouts AS (
         SELECT sum(amount) as payouts_sum
         FROM payment_to_partners
         WHERE partner_id =  17
     )
SELECT
    sum(d.income)/2 - payouts_sum as available_balance
FROM data d
         JOIN payouts p on 1=1
group by payouts_sum
