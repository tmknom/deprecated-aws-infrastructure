package builder

import (
	"time"

	"github.com/aws/aws-sdk-go/service/ec2"

	"../ami"
	"../tag"
)

type AmiBuilder struct {
	Ec2Api ec2.EC2
}

func (ab AmiBuilder) Build(instanceId string, role string, parentAmiId string) {
	// AMIの作成
	amiParam := ami.AmiParam{
		InstanceId: instanceId,
		Name:       role,
	}
	ami := ami.Ami{Ec2Api: ab.Ec2Api}
	imageId := ami.Create(amiParam)

	// タグの設定の準備
	snapshotId := ami.GetSnapshotId(*imageId)
	currentTime := time.Now()
	tagClient := tag.Tag{Ec2Api: ab.Ec2Api}

	// AMIのタグの設定
	amiTagParam := tag.AmiTagParam{
		AmiId:       *imageId,
		Role:        role,
		CurrentTime: currentTime,
		ParentAmiId: parentAmiId,
	}
	tagClient.CreateAmiTag(amiTagParam)

	// スナップショットのタグの設定
	snapshotTagParam := tag.SnapshotTagParam{
		SnapshotId:  *snapshotId,
		AmiTagParam: amiTagParam,
	}
	tagClient.CreateSnapshotTag(snapshotTagParam)
}
