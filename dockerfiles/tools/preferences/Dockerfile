ARG ARG_FROM

FROM $ARG_FROM AS dependencies

# Install VS Code
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add - && \
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

# Install developer dependencies
RUN apt-get update && \
    apt-get install -y \
    zsh \
    terminator \
    code && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

FROM dependencies AS preferences

# Install fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

# Install OhMyZSH
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN chsh -s /usr/bin/zsh root
RUN git clone https://github.com/bryceikeda/sky.git /root/.oh-my-zsh/custom/sky
RUN cp /root/.oh-my-zsh/custom/sky/.profile /root/
RUN ln -s /root/.oh-my-zsh/custom/sky/sky.zsh-theme /root/.oh-my-zsh/custom/
RUN ln -s /root/.oh-my-zsh/custom/sky/sky-hostname.zsh-theme /root/.oh-my-zsh/custom/
RUN sed -i -e 's/ZSH_THEME="robbyrussell"/[[ -n $SSH_CONNECTION ]] \&\& ZSH_THEME="sky-hostname" || ZSH_THEME="sky"/' /root/.zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN sed -i '/plugins=(git)/c\plugins=(git pyenv colored-man-pages command-not-found extract z zsh-autosuggestions)' /root/.zshrc

# Configure Terminator
RUN mkdir -p /root/.config/terminator/
COPY config/terminator_config /root/.config/terminator/config

# Configure ROS environment
RUN echo 'DISABLE_AUTO_UPDATE="true"' >> /root/.zshrc && \
    echo 'ENABLE_CORRECTION="false"' >> /root/.zshrc && \
    echo 'HYPHEN_INSENSITIVE="true"' >> /root/.zshrc && \
    echo "source /opt/ros/noetic/setup.zsh" >> /root/.zshrc && \
    echo "export ROSLAUNCH_SSH_UNKNOWN=1" >> /root/.zshrc && \
    echo "source /opt/underlay_ws/devel/setup.zsh" >> /root/.zshrc && \
    echo "source /opt/overlay_ws/devel/setup.zsh" >> /root/.zshrc

COPY config/entrypoint_setup.sh /
ENTRYPOINT ["/entrypoint_setup.sh"]

# Launch terminator
CMD ["terminator"]
