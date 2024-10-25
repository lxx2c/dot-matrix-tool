# 定义变量
$project_name = "dot-matrix-tool.exe"
$release_path = "..\..\build-dot-matrix-tool-Desktop_Qt_5_12_12_MinGW_64_bit-MinSizeRel"
$output_dir = "..\..\release"
$windeployqt_path = "C:\Qt\Qt5.12.12\5.12.12\mingw73_64\bin\windeployqt.exe"
$qml_dir = "C:\Qt\Qt5.12.12\5.12.12\mingw73_64\qml"

# 复制项目文件到输出目录
Write-Host "Copying $project_name from $release_path to $output_dir..."
if (-not (Test-Path $output_dir)) {
    New-Item -ItemType Directory -Path $output_dir
}
Copy-Item "$release_path\$project_name" "$output_dir"

# 在输出目录中运行 windeployqt
Write-Host "Running windeployqt..."
Set-Location $output_dir
& $windeployqt_path --qmldir=$qml_dir $project_name --release --no-system-d3d-compiler

Write-Host "Done."
