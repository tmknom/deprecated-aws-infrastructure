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

func (tag Tag) Create(amiTagParam AmiTagParam) {
	fmt.Println("Set the AMI tags")
	input := tag.createTagsInput(amiTagParam)
	tag.createTags(input)
}

func (tag Tag) createTags(input *ec2.CreateTagsInput) (*ec2.CreateTagsOutput, error) {
	return tag.Ec2Api.CreateTags(input)
}

func (tag Tag) createTagsInput(param AmiTagParam) *ec2.CreateTagsInput {
	return &ec2.CreateTagsInput{
		Resources: []*string{
			aws.String(param.AmiId),
		},
		Tags: []*ec2.Tag{
			tag.createTag("Name", param.Role+"-"+param.CurrentTime.Format("20060102-150405")),
			tag.createTag("Role", param.Role),
			tag.createTag("Created", strconv.FormatInt(param.CurrentTime.Unix(), 10)),
			tag.createTag("ParentAmiName", param.ParentAmiId),
		},
	}
}

func (tag Tag) createTag(k string, v string) *ec2.Tag {
	return &ec2.Tag{
		Key:   aws.String(k),
		Value: aws.String(v),
	}
}
