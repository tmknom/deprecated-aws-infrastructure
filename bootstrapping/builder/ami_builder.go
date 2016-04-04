package builder

import (
	"time"

	svc "github.com/aws/aws-sdk-go/service/ec2"

	"../ami"
	"../ec2"
	"../tag"
)

type AmiBuilder struct {
	Ec2Service *svc.EC2
}

func (ab AmiBuilder) Build(instanceId string, role string, parentAmiId string) {
	// EC2インスタンスを停止
	ec2.Ec2Instance{Ec2Api: *ab.Ec2Service}.Stop(instanceId)

	// AMIの作成
	amiParam := ami.AmiParam{
		InstanceId: instanceId,
		Name:       role,
	}
	ami := ami.Ami{Ec2Api: *ab.Ec2Service}
	imageId := ami.Create(amiParam)

	// タグの設定の準備
	snapshotId := ami.GetSnapshotId(*imageId)
	currentTime := time.Now()
	tagClient := tag.Tag{Ec2Api: *ab.Ec2Service}

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
