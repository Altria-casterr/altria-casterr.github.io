# 个人学术主页（GitHub Pages 版）

一个**单文件、零依赖**的个人主页，用来满足学术会议注册系统中
「提供一个显示姓名和邮箱的公开网址」这一要求。

```
personal-homepage/
├── index.html    ← 全部内容与样式都在这一个文件里（你只需要改这个）
├── publish.cmd   ← 双击或命令行运行，一键推送到 GitHub
├── deploy.ps1    ← publish.cmd 调用的 PowerShell 脚本
└── README.md     ← 本文档
```

---

## 一、内容已填好，只需确认

`index.html` 里已经写入：

| 位置 | 内容 |
|---|---|
| 标题 / 姓名 | 王森 · Sen Wang |
| 单位 | 苏州大学 未来科学与工程学院 · 人工智能 · 硕士 |
| 导师 | 李治军 教授 / Prof. Zhijun Li |
| 邮箱 | wangsanmu53@gmail.com（页面里出现两次，均为可见文本） |
| 研究方向 | 具身智能 / Embodied AI |
| 论文 | 暂无（保留区块，后续补） |
| GitHub | github.com/Altria-casterr |

需要修改时用记事本或 VS Code 打开 `index.html` 直接改文字即可，
改完双击文件在浏览器预览——**重点确认邮箱仍是可读文本**（注册审核认这个）。

后续想加论文，找 `<h2>Publications</h2>` 下面的那行占位文字，替换成
`<ul>` 列表即可。

---

## 二、创建 GitHub 仓库（在浏览器里做，5 分钟）

1. 登录或注册 [github.com](https://github.com)，用户名：`Altria-casterr`。
2. 右上角 **+ → New repository**。
3. **Repository name** 填：`Altria-casterr.github.io`
   （**必须完全一致**，这是根域名 `altria-casterr.github.io` 的前提）
4. 可见性选 **Public**（私有仓库用 Pages 需要付费账号）。
5. 下面的 `Add a README file` 等选项**全部不勾**，直接 **Create repository**。

---

## 三、把文件传上去（选一种）

### 方式 A：网页直接上传（最简单，不用装任何东西）

1. 打开刚创建的仓库，点 **Add file → Upload files**。
2. 把 `index.html` 拖进去（`README.md`、`deploy.ps1` 不用传，传了也没影响）。
3. 底部 **Commit changes**。
4. 进入 **Settings → Pages**：
   - **Source** 选 `Deploy from a branch`
   - **Branch** 选 `main`，目录选 `/ (root)` → **Save**
5. 等 1~2 分钟，访问 `https://你的用户名.github.io`。

### 方式 B：用脚本推送（推荐，一条命令）

先确认仓库已创建（见上一节），然后在本目录打开命令行
（在文件夹地址栏输入 `cmd` 回车即可），执行：

```bat
publish.cmd altria-casterr "Sen Wang" "wangsanmu53@gmail.com"
```

说明：

- 用户名写**小写**，GitHub 大小写不敏感，小写可以避免个别环境下的重定向问题。
- 后面两个参数是 commit 里显示的作者名字和邮箱，写成你想要的即可；不写会交互式询问。
- 你的电脑上已经存有 GitHub 账号凭证（Credential Manager 里有 `git:https://github.com`
  → `Altria-casterr`），正常情况下**不会**再弹登录窗口；万一弹了，按提示登录一次即可。
- 以后每次改完内容，再跑一次同样的命令即可。

> 如果你的 PowerShell 报「未对文件进行数字签名」，说明是执行策略限制。
> `publish.cmd` 已经用 `-ExecutionPolicy Bypass` 绕过，直接用它就行；
> 想手动跑 `.ps1` 的话改用：
> `powershell -ExecutionPolicy Bypass -File .\deploy.ps1 -UserName 你的用户名`

### 方式 C：手动 git 命令

```powershell
cd personal-homepage
git init -b main
git remote add origin https://github.com/你的用户名/你的用户名.github.io.git
git add -A
git commit -m "update homepage"
git push -u origin main
```

---

## 四、验证

打开 `https://你的用户名.github.io`，检查三件事：

- [ ] 姓名显示正确（中文 + 拼音）
- [ ] 邮箱是可见文本，点一下能唤起邮件客户端
- [ ] 手机上也正常（页面已做响应式）

把这个网址填进注册系统的「主页网址」字段即可，其余字段留空。

---

## 五、常见问题

**访问 404？**
按顺序排查：① 仓库名是否严格等于 `<用户名>.github.io`；② Settings → Pages 里
Branch 是否选了 `main` + `/ (root)`；③ 是否刚提交不到 1 分钟，等一会儿刷新；
④ 仓库里 `index.html` 是否在**根目录**而不是某个子文件夹里。

**国内访问慢或打不开？**
`*.github.io` 在国内部分网络下不稳定。可以在仓库里加一个 `CNAME` 文件绑定自己的域名，
或者换用 Gitee Pages / 学校提供的主页空间——本项目是纯静态文件，换托管方式只需上传同一个
`index.html`，无需改代码。

**改了内容怎么更新？**
改完 `index.html` 后再跑一次 `publish.cmd 你的用户名`，或网页上重新 Upload 覆盖。
改动一般 30 秒内生效。

**push 报 `Could not read from remote repository`？**
最可能是仓库还没建，或仓库名不是 `<用户名>.github.io`；其次是网络到不了 github.com。
可以先确认浏览器能打开 `https://github.com/你的用户名/你的用户名.github.io`，
再重跑脚本并在弹窗里完成授权。实在不行就用方式 A（网页上传），效果完全一样。

**邮箱被爬虫抓怎么办？**
先用正常可读形式（注册审核需要），通过后再改成 `name [at] example [dot] com`
或图片形式；如果你确实需要，告诉我，我给你加一个不破坏可读性的混淆写法。

**以后想加论文列表 / 项目截图？**
直接在 `index.html` 的 `Publications` 区块里照格式加一行即可；图片放同目录
（如 `assets/`），用相对路径引用。
