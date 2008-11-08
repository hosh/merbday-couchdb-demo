class Profiles < Application
  # provides :xml, :yaml, :js

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
      redirect resource(@profile), :message => {:notice => "Profile was successfully created"}
    else
      message[:error] = "Profile failed to be created"
      render :new
    end
  end

  def update(id, profile)
    @profile = Profile.get(id)
    raise NotFound unless @profile
    if @profile.update_attributes(profile)
       redirect resource(@profile)
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
