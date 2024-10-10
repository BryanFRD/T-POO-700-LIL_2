# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TimeManager.Repo
alias TimeManager.Users.User
alias TimeManager.Clocks.Clock
alias TimeManager.Workingtimes.Workingtime

# Add Faker for generating random data
{:ok, _} = Application.ensure_all_started(:faker)

# Create 10 users with random data
for _ <- 1..10 do
  user = Repo.insert!(%User{
    username: Faker.Internet.user_name,
    email: Faker.Internet.email,
  })

  # Create workingtime from here to 10 days ago going around 6am-10am to 4pm-10pm
  for time <- 1..10 do
    start_time = Faker.DateTime.backward(time * 24 * 60 * 60) |> DateTime.add(6 * 60 * 60 + :rand.uniform(4 * 60 * 60), :second)
    end_time = DateTime.add(start_time, 8 * 60 * 60 + :rand.uniform(8 * 60 * 60), :second)

    workingtime = Repo.insert!(%Workingtime{
      user_id: user.id,
      start: start_time,
      end: end_time,
    })
  end

end
