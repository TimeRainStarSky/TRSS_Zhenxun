#TRSS Termux PostgreSQL 安装脚本 作者：时雨🌌星空
NAME=v1.0.0;VERSION=202303020
R="[1;31m" G="[1;32m" Y="[1;33m" C="[1;36m" B="[1;m" O="[m"
echo "$B———————————————————————————————
$R TRSS$Y Termux$G PostgreSQL$C Script$O
      $G$NAME$C ($VERSION)$O
$B———————————————————————————————
       $G作者：$C时雨🌌星空$O"
abort(){ echo "
$R! $@$O";exit 1;}
type pkg &>/dev/null&&echo "
$Y- 正在安装 PostgreSQL$O
"||abort "找不到 pkg 命令，请确认安装了正确的 Termux 环境"
echo "extra-keys = [ ['ESC','<','>','BACKSLASH','=','^','$','()','{}','[]','ENTER'], ['TAB','&',';','/','~','%','*','HOME','UP','END','PGUP'], ['CTRL','FN','ALT','|','-','+','QUOTE','LEFT','DOWN','RIGHT','PGDN'] ]
terminal-onclick-url-open=true
terminal-margin-vertical=0
terminal-margin-horizo​​ntal=0">~/.termux/termux.properties
echo "foreground=#C5C8C6
background=#000000
cursor=#C5C8C6
color0=#1D1F21
color1=#CC342B
color2=#198844
color3=#FBA922
color4=#16B1FB
color5=#A36AC7
color6=#3971ED
color7=#C5C8C6
color8=#969896
color9=#CC342B
color10=#198844
color11=#FBA922
color12=#16B1FB
color13=#A36AC7
color14=#3971ED
color15=#FFFFFF
color16=#F96A38
color17=#3971ED
color18=#282A2E
color19=#373B41
color20=#B4B7B4
color21=#E0E0E0">~/.termux/colors.properties
termux-reload-settings
pkg update&&
pkg install -y postgresql||abort "PostgreSQL 安装失败"
echo "
$Y- 正在初始化 PostgreSQL$O
"
PGSQLDB="$HOME/postgres"
rm -rf "$PGSQLDB"&&
initdb -D "$PGSQLDB"||abort "PostgreSQL 初始化失败"
pg_ctl start -D "$PGSQLDB"&&
createdb&&
psql -c "CREATE USER zhenxun WITH PASSWORD 'TimeRainStarSky'"&&
psql -c "CREATE DATABASE zhenxun OWNER zhenxun"&&
pg_ctl stop -D "$PGSQLDB"||abort "数据库创建失败"
echo "
$G- PostgreSQL 安装完成，启动命令：${C}pg_ctl start -D ~/postgres$O"