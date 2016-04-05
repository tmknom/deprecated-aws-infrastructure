package role

import (
	"strings"
)

type Role string

const (
	BASE  Role = "base"
	RAILS Role = "rails"
)

func NewRole(value string) Role {
	return Role(strings.ToLower(value))
}

func (r Role) String() string {
	return string(r)
}

func (r Role) ToTag() string {
	lower := strings.ToLower(string(r))
	return strings.ToUpper(lower[:1]) + lower[1:]
}

func (r Role) Parent() Role {
	switch r {
	case RAILS:
		return BASE
	default:
		panic("No such parent role : " + r.String())
	}
}
