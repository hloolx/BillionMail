# 宝塔 Docker 编排部署

这套部署使用 GitHub Container Registry 里的专属镜像：

- `ghcr.io/hloolx/billionmail-core:dev`
- `ghcr.io/hloolx/billionmail-postfix:dev`
- `ghcr.io/hloolx/billionmail-dovecot:dev`
- `ghcr.io/hloolx/billionmail-rspamd:dev`

`postgres`、`redis`、`roundcube` 继续使用公开官方镜像。

## 1. 准备服务器目录

```bash
cd /opt
git clone -b dev https://github.com/hloolx/BillionMail.git
cd BillionMail
bash deploy/baota/init-env.sh
```

脚本会生成 `.env`，并输出后台登录入口、用户名和密码。如果你想手工配置，也可以复制模板：

```bash
cp deploy/baota/.env.example .env
```

手工配置时至少替换这些值：

```env
ADMIN_USERNAME=你的后台用户名
ADMIN_PASSWORD=你的后台密码
SafePath=一个随机入口路径
DBPASS=随机32位以上密码
REDISPASS=随机32位以上密码
```

可以用下面命令生成随机值：

```bash
openssl rand -base64 24 | tr -dc A-Za-z0-9 | head -c 32 && echo
```

## 2. 启动编排

命令行启动：

```bash
docker compose -f docker-compose.ghcr.yml up -d
```

宝塔里启动：

1. 进入「Docker」/「容器编排」
2. 选择 `/opt/BillionMail/docker-compose.ghcr.yml`
3. 项目目录选 `/opt/BillionMail`
4. 环境变量文件使用 `/opt/BillionMail/.env`
5. 创建并启动

## 3. 访问

后台地址：

```text
https://mail.oai.sb/你的SafePath
```

网页邮箱：

```text
https://mail.oai.sb/roundcube/
```

## 4. 常用命令

```bash
docker compose -f docker-compose.ghcr.yml ps
docker compose -f docker-compose.ghcr.yml logs -f core-billionmail
docker compose -f docker-compose.ghcr.yml pull
docker compose -f docker-compose.ghcr.yml up -d
```

## 5. DNS

`mail.oai.sb` 的 A 记录应指向服务器 IP，PTR/rDNS 应由 RackNerd 设置为 `mail.oai.sb`。

部署成功后，在项目目录执行：

```bash
bash bm.sh show-record oai.sb
```

按输出补齐 MX、SPF、DKIM、DMARC。
