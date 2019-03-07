customer = Customer.create name: 'Alpha', status: Customer.statuses[:active]
admin = User.create name: 'admin', password: 'admin', customer: customer, admin: true
