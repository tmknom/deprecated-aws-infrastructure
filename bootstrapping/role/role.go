package role

type Role string

const (
	BASE  Role = "base"
	RAILS Role = "rails"
)

func (r Role) String() string {
	return string(r)
}
