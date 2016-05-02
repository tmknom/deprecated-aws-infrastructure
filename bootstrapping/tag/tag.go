package tag

import (
	"fmt"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
)

type Tag struct {
	Ec2Api ec2.EC2
}

type AmiTagParam struct {
	AmiId       string
	Role        string
	CurrentTime time.Time
	ParentAmiId string
}

type SnapshotTagParam struct {
	SnapshotId  string
	AmiTagParam AmiTagParam
}

func (tag Tag) CreateAmiTag(amiTagParam AmiTagParam) {
	fmt.Println("Set the AMI tags")
	input := tag.createAmiTagsInput(amiTagParam)
	tag.createTags(input)
}

func (tag Tag) CreateSnapshotTag(snapshotTagParam SnapshotTagParam) {
	fmt.Println("Set the Snapshot tags")
	input := tag.createSnapshotTagsInput(snapshotTagParam)
	tag.createTags(input)
}

func (tag Tag) createTags(input *ec2.CreateTagsInput) (*ec2.CreateTagsOutput, error) {
	return tag.Ec2Api.CreateTags(input)
}

func (tag Tag) createAmiTagsInput(param AmiTagParam) *ec2.CreateTagsInput {
	return &ec2.CreateTagsInput{
		Resources: []*string{
			aws.String(param.AmiId),
		},
		Tags: tag.createAmiTags(param),
	}
}

func (tag Tag) createSnapshotTagsInput(param SnapshotTagParam) *ec2.CreateTagsInput {
	return &ec2.CreateTagsInput{
		Resources: []*string{
			aws.String(param.SnapshotId),
		},
		Tags: append(
			tag.createAmiTags(param.AmiTagParam),
			tag.createTag("AmiId", param.AmiTagParam.AmiId),
		),
	}
}

func (tag Tag) createAmiTags(param AmiTagParam) []*ec2.Tag {
	return []*ec2.Tag{
		tag.createTag("Name", param.Role+"-"+param.CurrentTime.Format("20060102-150405")),
		tag.createTag("Role", param.Role),
		tag.createTag("Created", strconv.FormatInt(param.CurrentTime.Unix(), 10)),
		tag.createTag("ParentAmiId", param.ParentAmiId),
	}
}

func (tag Tag) createTag(k string, v string) *ec2.Tag {
	return &ec2.Tag{
		Key:   aws.String(k),
		Value: aws.String(v),
	}
}
