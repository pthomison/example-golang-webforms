FROM fedora:36

RUN dnf update -y

RUN dnf install npm make ncurses unzip -y

RUN npm install -g npm

RUN npm install -g webpack webpack-cli style-loader css-loader eslint eslint-config-google eslint-plugin-vue