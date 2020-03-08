require_relative 'scripts/copy-dependencies'
require_relative 'scripts/utils'


# This task is temporary until we have an automated linux buold
task :create_linux_build, [:product_version, :build_dir] do |t, args|
  product_version = sanitized_version(args.product_version)
  build_dir = to_linux_path(args.build_dir)
  
  #run nuget to get linux packages
  # nuget_restore 'linux'

  tar_file_name = "ospsuite_#{product_version}.tar.gz"

  
  # Tar file produced by the script
  tar_file = File.join(build_dir, tar_file_name)

  #unzip it in a temp folder
  temp_dir = File.join(build_dir, "temp")
#  FileUtils.mkdir_p temp_dir
#  temp_dir = "C:/temp/"
  FileUtils.mkdir_p temp_dir

  command_line = %W[xzf #{tar_file} -C #{temp_dir}]
  Utils.run_cmd('tar', command_line)


   command_line = %W[czf #{File.join(build_dir, "test.tar.gz")}   -C #{temp_dir} ospsuite]
  Utils.run_cmd('tar', command_line)

  # ospsuite_dir = File.join(temp_dir,  'ospsuite')
  # inst_lib_diir = File.join(ospsuite_dir, 'inst', 'lib')

  #Remove the windows dll that should be replace by linux binaries
  # delete_dll('OSPSuite.FuncParserNative', inst_lib_diir)
  # delete_dll('OSPSuite.SimModelNative', inst_lib_diir)
  # delete_dll('OSPSuite.SimModelSolver_CVODES', inst_lib_diir)

  #Copy the linux binaries
  # copy_so('OSPSuite.FuncParser', inst_lib_diir)
  # copy_so('OSPSuite.SimModel', inst_lib_diir)
  # copy_so('OSPSuite.SimModelSolver_CVODES', inst_lib_diir)

  # puts "Temp Directory exists #{Dir.exists?(temp_dir)}"
  # puts "OSPSUITE  Directory exists #{Dir.exists?( File.join(temp_dir, "ospsuite"))}"

  #Recreate tar ball in temp file
  # temp_tar_file = File.join(temp_dir,  tar_file_name)
#  command_line = %W[czf #{temp_tar_file}  -C #{temp_dir} ospsuite]
# command_line = %W[cvzf #{tar_file_name}  #{temp_dir}]
# Utils.run_cmd('tar', command_line)

  #Last move new tar file and replace old tar file
 # FileUtils.copy_file(temp_tar_file, tar_file)
end

def sanitized_version(version) 
  pull_request_index = version.index('-')
  return version unless pull_request_index
  version.slice(0, pull_request_index)
end


def to_linux_path(path, end_slash=false)
  "#{'/' if path[0]=='\\'}#{path.split('\\').join('/')}#{'/' if end_slash}" 
end 

def to_win_path(path)
  path.split('/').join('\\')
end
