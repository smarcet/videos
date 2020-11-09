
# for warden, `:auth`` is just a name to identify the strategy
Warden::Strategies.add :auth, Auth::CustomAuth

# for devise, there must be a module named 'MyAuthentication' (name.to_s.classify), and then it looks to warden
# for that strategy. This strategy will only be enabled for models using devise and `:my_authentication` as an
# option in the `devise` class method within the model.
Devise.add_module :auth, :strategy => true
