
# This has to be a separate type to enable collecting
Puppet::Type.newtype(:pureftpd_user) do
  @doc = "Manage user for the PureDB auth method for the Pure-ftpd service"

  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the puredb user"
  end

  newproperty(:password) do
    desc "The password of the puredb user account"

    def insync?(current)
      provider.password_insync?(current,should)
    end

  end

  newproperty(:uid) do
    desc "The uid of the real user. Must be String."
    newvalue(/^\w+$/)

    def insync?(is)
      # We know the 'is' is a number, so we need to convert the 'should' to a number,
      # too.
      return true if number = Puppet::Util.uid(value) and is.to_i == number.to_i

      false
    end

    def sync
      number = Puppet::Util.uid(value)
      provider.uid = number

      # fail "Could not find group(s) #{@should.join(",")}" unless found

      # Use the default event.
    end
  end


  newproperty(:gid) do
    desc "The gid of the real use. Must be String."
    newvalue(/^\w+$/)

    def insync?(is)
      # We know the 'is' is a number, so we need to convert the 'should' to a number,
      # too.
      return true if number = Puppet::Util.gid(value) and is.to_i == number.to_i

      false
    end

    def sync
      number = Puppet::Util.gid(value)
      provider.gid = number

      # fail "Could not find group(s) #{@should.join(",")}" unless found

      # Use the default event.
    end

  end

  newproperty(:dir) do
    desc "Home directory of the puredb user for files"
  end

  autorequire(:user) do
    [self[:uid]]
  end

  autorequire(:group) do
    [self[:gid]]
  end

  autorequire(:file) do
    [self[:dir]]
  end


end
