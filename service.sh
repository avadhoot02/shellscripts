#!/bin/sh


LOG_FILE="/var/log/service_actions.log"

if [ ! -f "$LOG_FILE" ]; then
  touch "$LOG_FILE"
fi



# Function to enable a service by creating a symbolic link
enable_service() {
  local service_name="$1"
  local action="$2"
  
  # List of directories to search for services
  service_directories=(
 "/etc/rc.d/" 
  "/etc/rc2.d/" 
  "/etc/rc3.d/"
  "/etc/rc4.d/"
  "/etc/rc5.d/" 
  "/etc/rc6.d/" 
  
  "/etc/rc.d/custom/"
  "/etc/rc.d/rc0.d/"
  "/etc/rc.d/rc2.d/"
  "/etc/rc.d/rc4.d/"
  "/etc/rc.d/rc6.d/"
  "/etc/rc.d/service/"
  "/etc/rc.d/init.d/"  
  "/etc/rc.d/rc1.d/"
  "/etc/rc.d/rc3.d/" 
  "/etc/rc.d/rc5.d/" 
  "/etc/rc.d/rcS.d/"  
  "/etc/rc.d/service_options/"  
  "/etc/rc.d/ThinPrint/"
  

  )
  
  # Search for the service in the specified directories
  found_service=false
  for dir in "${service_directories[@]}"; do
    if [ -f "$dir$service_name" ]; then
     
  	  echo "service found "
  	  found_service=true
          $dir$service_name $action
          output=$("$dir$service_name" status 2>&1)
	  pid=$(echo "$output" | grep -o 'Process ID(s) [0-9]*' | awk '{print $NF}')
       #  if [ -z "$pid" ]; then
    	 #  echo "Process stopped"
       #  else
    	 #  echo " Process running with PID: "$pid" " 
      # 	fi          


  	  return_code=$?
          
	# Check if the action was successful
        if [ "$action" == "status" ] && [ -n "$pid"  ]; then
           echo -e "Service $service_name current status is : active ("$pid")"
        elif [ "$action" == "status" ] && [ -z "$pid"  ]; then
           echo -e "Service $service_name current status is : inactive"

        elif [ "$action" = "start" ] && [ -n "$pid" ]; then
           echo " Service '$service_name' is successfully started with  Process ID(s): $pid "
           echo -e  "[ $(date '+%Y-%m-%d %H:%M:%S') ] : [ Service '$service_name' is successfully started with  Process ID(s): $pid  ] \n" >> "$LOG_FILE"
        elif [ "$action" == "stop" ] && [ -z "$pid" ]; then
           echo " Service '$service_name' stopped "

           echo -e "[ $(date '+%Y-%m-%d %H:%M:%S') ]: [ Service  '$service_name'  is successfully stopped ] \n" >> "$LOG_FILE"
	elif [ "$action" == "restart" ] && [ -n "$pid" ]; then
           echo " Service '$service_name' restarted successfully "

           echo -e "[ $(date '+%Y-%m-%d %H:%M:%S') ]: [ Service  '$service_name'  is successfully restarted with Process ID(s): $pid ] \n" >> "$LOG_FILE"
        else
            if [ "$#" ==  2 ]; then
              echo "Failed! Please enter valid service and action then try again"
              
             #  echo -e "[ $(date '+%Y-%m-%d %H:%M:%S') ]: [ Service  "$service_name" action "$action" is Failed !  ] \n" >> "$LOG_FILE"
            fi
        fi
         break
  	# No need to search in other directories once service is found
    fi
    done

    if [ "$found_service" = false ]; then
    echo "Service $service_name not found in the specified directories."
    exit 1
    fi
}

# Check if a service name is provided
if [ $# ==  0 ]; then
  echo "Usage: $0 <service-name> <start>"
  echo "Usage: $0 <service-name> <stop>"
  echo "Usage: $0 <service-name> <status>"
  echo "Usage: $0 <service-name> <restart>"
  exit 1
fi

enable_service "$1" "$2"

