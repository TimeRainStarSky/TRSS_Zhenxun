#TRSS Zhenxun MSYS2 安装脚本 作者：时雨🌌星空
NAME=v1.0.0;VERSION=202212170
R="[1;31m";G="[1;32m";Y="[1;33m";C="[1;36m";B="[1;m";O="[m"
echo "$B—————————————————————————————
$R TRSS$Y Zhenxun$G Install$C Script$O
     $G$NAME$C ($VERSION)$O
$B—————————————————————————————
      $G作者：$C时雨🌌星空$O"
abort(){ echo "
$R! $@$O";exit 1;}
export LANG=zh_CN.UTF-8
DIR="${DIR:-$HOME/TRSS_Zhenxun}"
CMD="${CMD:-tszx}"
CMDPATH="${CMDPATH:-/usr/local/bin}"
MSYS2ENV=mingw-w64-ucrt-x86_64
type pacman &>/dev/null&&echo "
$Y- 正在安装依赖$O
"||abort "找不到 pacman 命令，请确认安装了正确的 MSYS2 环境"
pacman -Syu --noconfirm --needed --overwrite "*" curl dialog git tmux perl neofetch unzip fish ncdu $MSYS2ENV-ripgrep $MSYS2ENV-fd $MSYS2ENV-fzf $MSYS2ENV-bat ruby||abort "依赖安装失败"
type fastfetch &>/dev/null||ln -vsf neofetch "$(dirname "$(command -v neofetch)")/fastfetch"
[ -s /usr/bin/rg ]||echo -n 'exec /ucrt64/bin/rg "$@"'>/usr/bin/rg
[ -s /ucrt64/bin/fd ]&&mv -vf /ucrt64/bin/fd /ucrt64/bin/fdo
[ -s /usr/bin/fd ]||echo -n '/ucrt64/bin/fdo "$@"|cygpath -mf -'>/usr/bin/fd
[ -s /usr/bin/fzf ]||echo -n 'exec /ucrt64/bin/fzf "$@"'>/usr/bin/fzf
[ -s /usr/bin/bat ]||echo -n 'exec /ucrt64/bin/bat "$@"'>/usr/bin/bat
gem install lolcat

Title="TRSS Zhenxun Install Script $NAME ($VERSION)";BackTitle="作者：时雨🌌星空"
menubox(){ MenuBox="$1";shift;dialog --title "$Title" --backtitle "$BackTitle $(date "+%F %T.%N")" --ok-button "确认" --cancel-button "取消" --menu "$MenuBox" 0 0 0 "$@" 3>&1 1>&2 2>&3;}
mktmp(){ TMP="$DIR/tmp"&&rm -rf "$TMP"&&mkdir -p "$TMP"||abort "缓存目录创建失败";}
geturl(){ curl -L --retry 2 --connect-timeout 5 "$@";}
gitserver(){ [ -n "$URL" ]&&return
Choose="$(menubox "- 请选择 GitHub 镜像源"\
  1 "GitHub"\
  2 "GHProxy"\
  3 "GitClone"\
  4 "GHApi"\
  5 "abskoop"\
  6 "FastGit"\
  7 "FastGitRaw"\
  8 "FastGitRelease")"||return
case "$Choose" in
  1)Server="GitHub" URL="https://github.com";;
  2)Server="GHProxy" URL="https://ghproxy.com/github.com";;
  3)Server="GitClone" URL="https://gitclone.com/github.com";;
  4)Server="GHApi" URL="https://gh.api.99988866.xyz/github.com";;
  5)Server="abskoop" URL="https://github.abskoop.workers.dev/github.com";;
  6)Server="FastGit" URL="https://hub.fastgit.xyz";;
  7)Server="FastGitRaw" URL="https://raw.fastgit.org";;
  8)Server="FastGitRelease" URL="https://download.fastgit.org"
esac;}

type ffmpeg &>/dev/null||{ echo "
$Y- 正在安装 FFmpeg$O
"
gitserver||exit
mktmp
geturl "$URL/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl-shared.zip">"$TMP/ffmpeg.zip"||abort "下载失败"
unzip -oq "$TMP/ffmpeg.zip" -d "$TMP"||abort "解压失败"
mv -vf "$TMP/"*/bin/* /usr/bin||abort "安装失败";}

type python &>/dev/null||{ echo "
$Y- 正在安装 Python 3.10.8$O
"
mktmp
geturl "https://registry.npmmirror.com/-/binary/python/3.10.8/python-3.10.8-embed-amd64.zip">"$TMP/python.zip"||abort "下载失败"
mkdir -vp /usr/share/python/lib&&\
unzip -oq "$TMP/python.zip" -d /usr/share/python&&\
unzip -oq /usr/share/python/*.zip -d /usr/share/python/lib&&\
rm -vrf /usr/share/python/*.zip /usr/share/python/*._pth||abort "解压失败"
echo -n "import sys
import io
sys.stdin = io.TextIOWrapper(sys.stdin.buffer,encoding='utf8')
sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='utf8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer,encoding='utf8')">/usr/share/python/sitecustomize.py&&\
echo -n 'exec /usr/share/python/python "$@"'>/usr/bin/python||abort "安装失败";}

type pip &>/dev/null||{ echo "
$Y- 正在安装 pip$O
"
mktmp
geturl "https://bootstrap.pypa.io/pip/pip.pyz">"$TMP/pip.pyz"||abort "下载失败"
python "$TMP/pip.pyz" config set global.index-url "https://pypi.mirrors.ustc.edu.cn/simple"&&\
python "$TMP/pip.pyz" install -U pip&&\
echo -n 'exec python -m pip "$@"'>/usr/bin/pip||abort "安装失败";}

type poetry &>/dev/null||{ echo "
$Y- 正在安装 Poetry$O
"
pip install -U poetry&&\
echo -n 'exec python -m poetry "$@"'>/usr/bin/poetry||abort "安装失败";}

type nginx &>/dev/null||{ echo "
$Y- 正在安装 Nginx$O
"
mktmp
GETVER="$(geturl "https://nginx.org/download"|grep 'href=".*\.zip<'|sed 's|.*href="||;s|\.zip.*|.zip|'|sort -V|tail -n 1)"&&\
geturl "https://nginx.org/download/$GETVER">"$TMP/nginx.zip"||abort "下载失败"
unzip -oq "$TMP/nginx.zip" -d "$TMP"||abort "解压失败"
rm -rf /usr/share/nginx&&\
mv -vf "$TMP/"*/ /usr/share/nginx&&\
echo -n 'cd /usr/share/nginx
exec ./nginx "$@"'>/usr/bin/nginx||abort "安装失败";}

abort_update(){ echo "
$R! $@$O";[ "$N" -lt 10 ]&&{ ((N++));download;}||abort "脚本下载失败，请检查网络，并尝试重新下载";}
download(){ case "$N" in
  2)SERVER="GitHub" URL="https://github.com/TimeRainStarSky/TRSS_Zhenxun/raw/main";;
  1)SERVER="Gitee" URL="https://gitee.com/TimeRainStarSky/TRSS_Zhenxun/raw/main";;
  3)SERVER="Agit" URL="https://agit.ai/TimeRainStarSky/TRSS_Zhenxun/raw/branch/main";;
  4)SERVER="Coding" URL="https://trss.coding.net/p/TRSS/d/Zhenxun/git/raw/main";;
  5)SERVER="GitLab" URL="https://gitlab.com/TimeRainStarSky/TRSS_Zhenxun/raw/main";;
  6)SERVER="GitCode" URL="https://gitcode.net/TimeRainStarSky1/TRSS_Zhenxun/raw/main";;
  7)Server="GitLink" URL="https://gitlink.org.cn/api/TimeRainStarSky/TRSS_Zhenxun/raw?ref=main&filepath=";;
  8)SERVER="JiHuLab" URL="https://jihulab.com/TimeRainStarSky/TRSS_Zhenxun/raw/main";;
  9)SERVER="Jsdelivr" URL="https://cdn.jsdelivr.net/gh/TimeRainStarSky/TRSS_Zhenxun@main";;
  10)SERVER="Bitbucket" URL="https://bitbucket.org/TimeRainStarSky/TRSS_Zhenxun/raw/main"
esac
echo "
  正在从 $SERVER 服务器 下载版本信息"
GETVER="$(geturl "$URL/version")"||abort_update "下载失败"
NEWVER="$(sed -n s/^version=//p<<<"$GETVER")"
NEWNAME="$(sed -n s/^name=//p<<<"$GETVER")"
NEWMD5="$(sed -n s/^md5=//p<<<"$GETVER")"
[ -n "$NEWVER" ]&&[ -n "$NEWNAME" ]&&[ -n "$NEWMD5" ]||abort_update "下载文件版本信息缺失"
echo "
$B  最新版本：$G$NEWNAME$C ($NEWVER)$O

  开始下载"
mkdir -vp "$DIR"
geturl "$URL/Main.sh">"$DIR/Main.sh"||abort_update "下载失败"
[ "$(md5sum "$DIR/Main.sh"|head -c 32)" != "$NEWMD5" ]&&abort_update "下载文件校验错误"
mkdir -vp "$CMDPATH"&&echo -n "exec bash '$DIR/Main.sh' "'"$@"'>"$CMDPATH/$CMD"&&chmod 755 "$CMDPATH/$CMD"||abort "脚本执行命令 $CMDPATH/$CMD 设置失败，手动执行命令：bash '$DIR/Main.sh'"
echo "
$G- 脚本安装完成，启动命令：$CMD$O";exit;}
echo "
$Y- 正在下载脚本$O";N=1;download