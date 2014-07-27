if User.all.size == 0
  User.create(
    email: 'admin@example.com',
    password: '12345678',
    password_confirmation: '12345678'
  )
end
