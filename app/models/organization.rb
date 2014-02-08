class Organization < ActiveRecord::Base
  
  has_many :users, through: :memberships
  has_many :admins, -> { where('organizations_users.admin = ?', true) },
           :through => :memberships, :source => :user
  has_many :memberships
  has_many :groups
  has_many :charges, as: :chargeable

  def set_password(clear_text)
    # not super secure due to no salt value but oh well
    self.password = Digest::SHA1.hexdigest(clear_text)
  end

  def is_password?(clear_text)
    return self.password == Digest::SHA1.hexdigest(clear_text)
  end

  def membership_type(user)
    @membership = Membership.where(:user => user, :organization => self)
    if @membership.exists?
      @membership = @membership[0]
      if @membership.admin
        return 'Admin'
      else
        return 'Member'
      end
    end
    return 'Not Member'
  end

  def is_admin(user)
    return self.memberships.where(:user => user, :admin => true).exists?
  end
end
