# == Class: composer::project_factory
#
# Class responsible for creating a load of projects.
#
# [*projects*]
#   A hash with the projects to be created.
#
#
class composer::project_factory (
  $projects = hiera_hash('composer::project_factory::projects', {}),
) {

  if $projects {
    create_resources('composer::project', $projects) 
  }
}
