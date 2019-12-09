FROM ubuntu:19.10

MAINTAINER "easytyger@gmail.com"

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ADD dotenv /root/.dotenv
RUN apt update -y && \
apt install -y bat \
build-essential \
cmake \
curl \
fasd \
git \
htop \
ncdu \
powerline \
python3-dev \
rsync \
vim \
wget \
zsh \
&& rm -rf /var/lib/apt/lists/*
RUN chsh -s `which zsh`
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN ~/.fzf/install
RUN git clone --separate-git-dir=$HOME/.dotfiles https://github.com/chewrocca/.dotfiles.git tmpdotfiles
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
RUN rm -r tmpdotfiles
RUN git clone https://github.com/powerline/fonts.git --depth=1
RUN ./fonts/install.sh
RUN rm -rf fonts
RUN vim --not-a-term +'PlugInstall --sync' +qall
RUN python3 ~/.vim/plugged/YouCompleteMe/install.py
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py
RUN pip3 install tldr
WORKDIR /home
