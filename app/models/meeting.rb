# == Schema Information
#
# Table name: meetings
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  end_time    :datetime
#  notes       :text
#  start_time  :datetime         not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  club_id     :bigint(8)        not null
#
# Indexes
#
#  index_meetings_on_club_id  (club_id)
#
# Foreign Keys
#
#  fk_rails_...  (club_id => clubs.id)
#

class Meeting < ApplicationRecord
  belongs_to :club, inverse_of: :meetings
  has_many :attendances, inverse_of: :meeting, dependent: :destroy

  validates :start_time, presence: true
  validate :end_time_after_start_time
  validates :club, presence: true

  scope :future, -> { where("start_time > ?", Date.current) }
  scope :past, -> { where("start_time <= ?", Date.current) }

  def associated_with?(user)
    club.users.include? user
  end

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?

    errors.add(:end_time, :after_start_time) if end_time < start_time
  end
end
