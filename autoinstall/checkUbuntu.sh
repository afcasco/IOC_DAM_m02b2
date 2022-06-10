# First check for compatible ubuntu version
COMPATIBLE=0
if [[ $(lsb_release -rs) == "20.04" ]]; then 

       echo "Focal Fossa found"
      
elif [[ $(lsb_release -rs) == "20.04" ]]; then 
       echo "Jammy Jellyfish"
else
	exit 0;
fi
