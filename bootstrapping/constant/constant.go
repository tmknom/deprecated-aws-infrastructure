package constant

// BaseAMIの元イメージ
// Amazon Linuxが新しくなるたびに書き換える前提
// 自動で取ってこれるとカッコいいが面倒なのでベタ書き
// Amazon Linux AMI 2016.03.0 (HVM), SSD Volume Type
const (
	BASE_IMAGE_ID = "ami-f80e0596"
)

// EC2インスタンスのパラメータ
const (
	SUBNET_NAME                        = "Administration-Public-Subnet-0"
	SSH_SECURITY_GROUP_NAME            = "Administration-SSH-SecurityGroup"
	INITIALIZATION_SECURITY_GROUP_NAME = "Administration-Initialization-SecurityGroup"
	INITIALIZATION_KEY_NAME            = "initialization"
	INITIALIZATION_INSTANCE_PROFILE    = "InitializationInstanceProfile"
	BASE_INSTANCE_TYPE                 = "t2.micro"
	BASE_VOLUME_SIZE                   = 8
)

// デフォルトリージョン
const (
	DEFAULT_REGION = "ap-northeast-1"
)
