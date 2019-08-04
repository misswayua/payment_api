# PromoCode

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Guidelines
#### create a new promo code 
 `curl -H "Content-Type: application/json" -X POST -d '{"promo_code":{"amount":"42", "is_active": true, "has_expired": "false"}}'http://localhost:4000/api/promo_codes` 
    
The expected  ouput is:
   `{"data":{"amount":42,"code":"3fec32b0-c62a-40e8-84d1-a8789a30f34e","has_expired":false,"is_active":true}}`

#### set promocode to expire
`curl -H "Content-Type: application/json" -X POST  http://localhost:4000/api/promo_codes/expire/"3fec32b0-c62a-40e8-84d1-a8789a30f34e"`
    
  The expected  ouput is:
   `{"data":{"amount":42,"code":"3fec32b0-c62a-40e8-84d1-a8789a30f34e","has_expired":true,"is_active":true}}`
####  Deactivate the promo code
 `curl -H "Content-Type: application/json" -X POST  http://localhost:4000/api/promo_codes/deactivate/"3fec32b0-c62a-40e8-84d1-a8789a30f34e"`
 
The expected output is: 
 `{"data":{"amount":42,"code":"3fec32b0-c62a-40e8-84d1-a8789a30f34e","has_expired":true,"is_active":false}}`

#### Return Active promo codes 
Return either an empty list or a list of active promo_codes
    `curl -H "Content-Type: application/json" -X GET  http://localhost:4000/api/promo_codes/active_promocodes`
 The expected output is:  
 ` {"data":[]}`
#### Return all promo codes
   `curl -H "Content-Type: application/json" -X GET http://localhost:4000/api/promo_codes`
   
   The expected output is:
 ` {"data":[{"amount":42,"code":"3fec32b0-c62a-40e8-84d1-a8789a30f34e","has_expired":true,"is_active":false}]}`
#### Validity of promo code
It is valid if it is within x radius from the event.
 `curl -H "Content-Type: application/json" -X POST -d '{"attrs": {"code":"3fec32b0-c62a-40e8-84d1-a8789a30f34e", "origin": ["2.0", "3.0"], "destination": ["5.0", "7.0"]}}' http://localhost:4000/api/promo_codes/valid`
 The expected output is:
` {"data":{"amount":42,"code":"3fec32b0-c62a-40e8-84d1-a8789a30f34e","has_expired":true,"is_active":false,"polyline":"_evi@_qo]~flW~|hQ", radius: "1.00"}}`
 
## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix