#!/bin/bash

#Arguments:
#1: mode
#2: working directory. required for run mode.
#3: number of processors/cores. required for run mode.
#4: the binary. required for run mode.

###################################
echo "# Following established in interface.sh entrypoint:" >> ~/.bashrc
echo 'PS1="\[\e[0;49;34m\]\\u@\h[\!]:\[\e[m\]\\w> "' >> ~/.bashrc

###################################
## compile
if [[ "${1}" == 'compile' ]]; then

    echo -e "\e[4;49;34m WRF-Hydro Development Docker: $1 mode \e[0m"

    ## Work in $HOME
    cd $HOME

    ## JLM: would prefer to work directly in /wrf_hydro which is the git repo on the local
    ##      machine. But I get strage issues, seemingly related to CPP (though not totall sure).
    ##      Source *.F files are modified and deleted in the repo and compilation fails.
    ##      WORKAROUND is to copy all source files to the joedocker user home and

    ## WRF-Hydro source
    ## JLM: I would like to compile in place and NOT copy, but get strange CPP? behavoir even
    ##      using gosu. See docker file gosu section. Is it a permissions issue?

echo "    _-\`\`\`\`\`-,           ,- '- ."
echo " .'   .- - |          | - -.  \`."
echo " /.'  /                     \`.   \ "
echo ":/   :      _...   ..._      \`\`   :"
echo "::   :     /._ .\`:'_.._\.    ||   :"
echo "::    \`._ ./  ,\`  :    \ . _.''   ."
echo "\`:.      /   |  -.  \-. \\_      /"
echo "  \:._ _/  .'   .@)  \@) \` \`\ ,.'"
echo "     _/,--'       .- .\,-.\`--\`."
echo "       ,'/''     (( \ \`  )    "
echo "        /'/'  \    \`-'  (      "
echo "         '/''  \`._,-----' "
echo "          ''/'    .,---'"
echo "           ''/'      ;:"
echo "             ''/''  ''/"
echo "               ''/''/''"
echo "                 '/'/'"
echo "                  \`;"
echo
echo "          _______   ____  __"
echo "         / ____/ | / / / / / "
echo "        / / __/  |/ / / / /"
echo "       / /_/ / /|  / /_/ /"
echo "       \____/_/ |_/\____/"
echo

    cp -r /wrf_hydro .
    cd wrf_hydro/src

    ## Enforce gfortran, skip the configure script with this

    echo "NETCDF_INC = ${NETCDF}/include" > macros.tmp
    echo "NETCDF_LIB = ${NETCDF}/lib" >> macros.tmp
    echo "NETCDFLIB  = -L\$(NETCDF_LIB) -lnetcdff -lnetcdf" >> macros.tmp
    if [[ -e macros ]]; then rm -f macros; fi
    cp arc/macros.mpp.gfort macros
    cp arc/Makefile.mpp Makefile.comm
    if [[ ! -e lib ]]; then mkdir lib; fi
    if [[ ! -e mod ]]; then mkdir mod; fi
    if [[ -e macros.tmp ]]; then
	cat macros macros.tmp > macros.a
	rm -f macros.tmp; mv macros.a macros
    fi

    cat macros

    ## Make build
    if [[ ! -e use_env_compileTag_offline_NoahMP.sh ]]; then
        cp /wrf_hydro_tools/utilities/use_env_compileTag_offline_NoahMP.sh .
    fi
    ## pass a dummy argument for no configure selection
    ./use_env_compileTag_offline_NoahMP.sh Z

    ## Bring a runnable binary back to the host machine.
    ## JLM: WHY does this work of the in-place compilation is a permissions issue?
    if [[ $? -eq 0 ]]; then
        lastBin=`ls -rt Run/* | tail -n1`
        chmod 777 $lastBin
        cp -L  $lastBin /wrf_hydro/src/Run/.
    else
        echo 'Compilation not successful'
        exit 1
    fi


    ## Cleanup
    ## rm -rf ~/wrf_hydro ~/.wrf_hydro_tools
    exit $?

fi

###################################
## run
if [[ "${1}" == 'run' ]]; then

    echo -e "\e[4;49;34m WRF-Hydro Development Docker: $1 mode \e[0m"

    workDir=$2
    nCores=$3
    theBin=$4

    if [[ -z $workDir ]]; then
	echo "Working directory not specified as the second argument for run mode, exiting."
	exit 1
    fi

    if [[ -z $nCores ]]; then
	echo "Number of processors/cores not specified as second argument to run_docker, exiting."
	exit 1
    fi

    if [[ -z $theBin ]]; then
	echo "The binary was not specified as third argument to run_docker, exiting."
	exit 1
    fi

    # change the working dir or dy trying
    cd $workDir || \
	{ echo "Cannot switch to working dir ($workDir) on docker, exiting."; exit 1; }

    ## enforce the number of processors?

    ## enforce existence of the binary file
    if [[ ! -e $theBin ]]; then
	echo "The binary speficied (${theBin}) does not exist."
	exit 1
    fi

    mpiexec -n $nCores ./${theBin} > >(tee -a wrf_hydro.stdout) 2> >(tee -a wrf_hydro.stderr >&2)

    exit $?

fi

###################################
## interactive
if [[ "${1}" == 'interactive' ]]; then

    echo -e "\e[4;49;34m WRF-Hydro Development Docker: $1 mode \e[0m"

    if [[ ! -z $2 ]]; then cd $2; fi

    ## OSX: The mounting is setup to only include the requesting user from /Users/`whoami`
    ##      Under other systems, this will fail silently (no way to detect HOST system?).
    cp /Users/*/.wrf_hydro_tools ~/. > /dev/null 2>&1

    exec /bin/bash

    #exec "$@"
    exit $?

fi


## Otherwise
echo -e "\e[4;49;34m WRF-Hydro Development Docker: command mode \e[0m"

#exec "$@"
"$@"
retValue=$?
echo $retValue

if [[ $retValue -ne 0 ]]; then
    exec /bin/bash
fi

exit 0
