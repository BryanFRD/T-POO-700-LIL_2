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
alias TimeManager.Workingtimes.Workingtime

# Add Faker for generating random data
{:ok, _} = Application.ensure_all_started(:faker)

# Create 10 users with random data
for _ <- 1..10 do
  user = Repo.insert!(%User{
    username: Faker.Internet.user_name,
    email: Faker.Internet.email,
  })

  # Create 10 workingtimes for each user going x days behind today from 6-10am to 4-10pm
  for day <- 1..10 do
    for hour <- 6..16 do
      workingtime = Repo.insert!(%Workingtime{
        user_id: user.id,
        start: Timex.now() |> Timex.shift(days: -day) |> Timex.shift(hours: hour) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),
        end: Timex.now() |> Timex.shift(days: -day) |> Timex.shift(hours: hour + 8) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),
      })
    end
  end
end
