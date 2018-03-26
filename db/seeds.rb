admin = User.create name: 'admin', password: 'admin', email: 'admin@email.com'
admin_role = Role.create name: 'Site Admin'
admin_group = Group.create name: 'Site Admin'

admin.groups << admin_group
admin.roles << admin_role
