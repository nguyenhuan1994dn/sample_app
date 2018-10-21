module UsersHelper
  def gravatar_for user, options = {size: Settings.helpers.users_helper.size}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def authorization_delete user
    return unless current_user.admin? && !current_user?(user)
    link_to t(".link_delete"), user, method: :delete,
      data: {confirm: t(".cf_sure")}
  end
end
