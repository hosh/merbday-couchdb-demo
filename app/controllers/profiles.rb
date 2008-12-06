class Profiles < Application
  provides :json

  def index
    @profiles = Profile.all
    display @profiles
  end

  def show(id)
    @profile = Profile.get(id)
    raise NotFound unless @profile
    display @profile
  end

  def new
    only_provides :html
    @profile = Profile.new
    display @profile
  end

  def edit(id)
    only_provides :html
    @profile = Profile.get(id)
    raise NotFound unless @profile
    display @profile
  end

  def create(profile)
    @profile = Profile.new(profile)
    if @profile.save
      # Should use resource(@profile) here, but CouchRest 0.9.15 doesn't interact with Merb like that
      redirect url(:profile, @profile.id), :message => {:notice => "Profile was successfully created"}
    else
      message[:error] = "Profile failed to be created"
      render :new
    end
  end

  def update(id, profile)
    @profile = Profile.get(id)
    raise NotFound unless @profile
    # Kludge. What really should happen is Profile accept an arbitrary json that updates everything
    @profile['contact_info'] = profile.delete('contact_info') if profile['contact_info']
    @profile['skills'] = profile.delete('skills') if profile['skills']
    if @profile.update_attributes(profile)
       redirect url(:profile, @profile.id)
    else
      display @profile, :edit
    end
  end

  def destroy(id)
    @profile = Profile.get(id)
    raise NotFound unless @profile
    if @profile.destroy
      redirect resource(:profiles)
    else
      raise InternalServerError
    end
  end

end # Profiles
