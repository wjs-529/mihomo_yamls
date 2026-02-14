import os
import json
import subprocess
import datetime
import shutil

WORKSPACE_DIR = "workspace"
OLD_STATS_FILE = "old_data/stats.json"
STATS_FILE = os.path.join(WORKSPACE_DIR, "stats.json")
README_FILE = os.path.join(WORKSPACE_DIR, "README.md")

def run_command(cmd):
    """运行系统命令"""
    try:
        subprocess.check_call(cmd, shell=True, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    except subprocess.CalledProcessError:
        print(f"⚠️ Warning: Command failed: {cmd}")

def count_lines(filepath):
    """计算文件行数"""
    try:
        with open(filepath, 'rb') as f:
            return sum(1 for _ in f)
    except:
        return 0

def process_dat_files():
    """遍历目录，解包 dat 文件，并返回统计数据"""
    current_stats = {}
    
    # 遍历 workspace 下的所有作者目录
    for author in os.listdir(WORKSPACE_DIR):
        author_path = os.path.join(WORKSPACE_DIR, author)
        if not os.path.isdir(author_path):
            continue
            
        print(f"🔍 Analyzing {author}...")
        current_stats[author] = {}

        # 遍历作者目录下的子文件夹 (geoip, geosite)
        for category in ["geoip", "geosite"]:
            cat_dir = os.path.join(author_path, category)
            if not os.path.exists(cat_dir):
                continue
                
            # 找到目录下的 .dat 文件
            for file in os.listdir(cat_dir):
                if not file.endswith(".dat"):
                    continue
                
                dat_path = os.path.join(cat_dir, file)
                # 创建导出目录
                export_dir = os.path.join(cat_dir, f"{file}_text")
                if os.path.exists(export_dir):
                    shutil.rmtree(export_dir)
                os.makedirs(export_dir, exist_ok=True)
                
                print(f"  -> Extracting {file}...")
                
                # --- 使用 v2dat 进行解包 ---
                # 语法: v2dat unpack geoip -o <output_dir> <dat_file>
                #       v2dat unpack geosite -o <output_dir> -f <filter_list> <dat_file>
                
                mode = "geoip" if "geoip" in file.lower() else "geosite"
                
                try:
                    # 尝试解包
                    # 注意：v2dat unpack 会把所有分类解压成单独的文件到指定目录
                    run_command(f"v2dat unpack {mode} -o {export_dir} {dat_path}")
                    
                    # 统计解包后的文件
                    if os.path.exists(export_dir):
                        files = os.listdir(export_dir)
                        # 挑选几个关键文件进行统计，避免统计几千个文件
                        target_tags = ["cn", "google", "telegram", "private", "apple"]
                        
                        # 如果是 geoip，统计 CN 和 US 等
                        # 如果是 geosite，统计 google, cn 等
                        
                        for tag_file in files:
                            tag_name = os.path.splitext(tag_file)[0]
                            # 只统计感兴趣的 Tag，或者你可以去掉这个 if 统计所有
                            if tag_name in target_tags or len(files) < 20: 
                                full_path = os.path.join(export_dir, tag_file)
                                count = count_lines(full_path)
                                current_stats[author][f"{file}::{tag_name}"] = count
                                
                except Exception as e:
                    print(f"Failed to unpack {file}: {e}")

    return current_stats

def generate_markdown(current_stats, old_stats):
    """生成 README.md"""
    lines = ["# 🌍 GeoData Assets & Analytics", ""]
    lines.append(f"> Last Updated: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} (UTC+8)")
    lines.append("")
    
    lines.append("## 📊 规则统计与变化")
    
    for author, rules in current_stats.items():
        if not rules: continue
        
        lines.append(f"### 👤 {author}")
        lines.append("| 文件::标签 | 条目数量 | 较昨日变化 |")
        lines.append("|---|---|---|")
        
        for key, count in sorted(rules.items()):
            # 计算 Diff
            old_count = old_stats.get(author, {}).get(key, 0)
            diff = count - old_count
            
            diff_str = "0"
            if diff > 0: diff_str = f"🔺 +{diff}"
            elif diff < 0: diff_str = f"🔻 {diff}"
            
            lines.append(f"| {key} | {count} | {diff_str} |")
        lines.append("")

    lines.append("## 📂 目录结构说明")
    lines.append("- **geoip/**: 二进制 geoip.dat")
    lines.append("- **geosite/**: 二进制 geosite.dat")
    lines.append("- **xxx_text/**: 解包后的文本规则 (方便 Grep 或 转换)")
    
    with open(README_FILE, "w", encoding='utf-8') as f:
        f.write("\n".join(lines))
    
    # 保存当前的 stats 以备下次对比
    with open(STATS_FILE, "w", encoding='utf-8') as f:
        json.dump(current_stats, f, indent=2)

def main():
    print("⏳ Loading old stats...")
    old_stats = {}
    if os.path.exists(OLD_STATS_FILE):
        try:
            with open(OLD_STATS_FILE, 'r') as f:
                old_stats = json.load(f)
        except:
            print("Old stats file corrupted, skipping diff.")

    print("⏳ Processing assets...")
    current_stats = process_dat_files()
    
    print("⏳ Generating report...")
    generate_markdown(current_stats, old_stats)
    print("✅ Done.")

if __name__ == "__main__":
    main()
