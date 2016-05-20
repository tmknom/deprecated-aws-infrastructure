package role

import (
	"strings"
)

type Role string

const (
	BASE            Role = "base"
	RAILS           Role = "rails"
	TECH_NEWS       Role = "tech_news"
	WONDERFUL_WORLD Role = "wonderful_world"
)

func NewRole(value string) Role {
	return Role(strings.ToLower(value))
}

func (r Role) String() string {
	return string(r)
}

func (r Role) ToTag() string {
	underscoreToSpace := strings.Replace(string(r), "_", " ", -1)
	toTitled := strings.Title(underscoreToSpace)
	return strings.Replace(toTitled, " ", "", -1)
}

func (r Role) Parent() Role {
	switch r {
	case RAILS:
		return BASE
	case TECH_NEWS:
		return RAILS
	case WONDERFUL_WORLD:
		return RAILS
	default:
		panic("No such parent role : " + r.String())
	}
}
