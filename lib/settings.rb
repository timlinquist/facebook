class Settings < SettingsLogic
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env
end
