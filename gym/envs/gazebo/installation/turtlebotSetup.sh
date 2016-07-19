#!/bin/sh

# Create catkin_ws
ws="catkin_ws"
if [ -d $ws ]; then
  echo "Error: catkin_ws directory already exists" 1>&2
  exit 1
fi
src=$ws"/src"

if [ -z "$GAZEBO_MODEL_PATH" ]; then
  bash -c 'echo "export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:"`pwd`/../assets/models >> ~/.bashrc'
  exec bash #reload bashrc
fi

#Load turtlebot variables. Temporal solution
chmod +x $src/turtlebot_simulator/turtlebot_gazebo/env-hooks/25.turtlebot-gazebo.sh.em
bash $src/turtlebot_simulator/turtlebot_gazebo/env-hooks/25.turtlebot-gazebo.sh.em

#add turtlebot launch environment variable
if [ -z "$GYM_GAZEBO_WORLD_MAZE" ]; then
  bash -c 'echo "export GYM_GAZEBO_WORLD_MAZE="`pwd`/../assets/worlds/maze.world >> ~/.bashrc'
  exec bash #reload bashrc
fi

#copy altered urdf model
bash -c "cp -r ../assets/urdf/kobuki_urdf/urdf/ catkin_ws/src/kobuki/kobuki_description"

if [ -z "$GAZEBO_PLUGIN_PATH" ]; then
  bash -c 'echo "export GAZEBO_PLUGIN_PATH=$GAZEBO_PLUGIN_PATH:"`pwd`/catkin_ws/build_isolated/iterations_gazebo_plugin >> ~/.bashrc'
  exec bash #reload bashrc
fi
