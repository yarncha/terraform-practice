// 프로바이더 구성
provider "local" {
}

// 새로운 파일 추가
resource "local_file" "foo" {
  // path.module은 해당 파일이 위치한 디렉토리 경로
  filename = "${path.module}/foo.txt"
  content  = "Hello World!"
}

// 파일 읽기
data "local_file" "bar" {
  filename = "${path.module}/bar.txt"
}

// 파일 출력
output "file_bar" {
  value = data.local_file.bar
}
