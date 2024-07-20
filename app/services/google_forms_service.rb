class GoogleFormsService
  FORMS = Google::Apis::FormsV1

  def initialize
    @service = FORMS::FormsService.new
    @service.authorization = authorize
  end

  def create_form(title, questions)
    form = FORMS::Form.new(info: FORMS::Info.new(title: title))
    form = @service.create_form(form)
    enable_grading(form.form_id)
    add_questions_to_form(form.form_id, questions)
    make_form_public(form.form_id)
    form
  end

  private

  def enable_grading(form_id)
    update_request = Google::Apis::FormsV1::BatchUpdateFormRequest.new(
      requests: [
        {
          update_settings: {
            settings: {
              quiz_settings: {
                is_quiz: true
              }
            },
            update_mask: "quiz_settings"
          }
        }
      ]
    )
    @service.batch_update_form(form_id, update_request)
  end

  def add_questions_to_form(form_id, questions)
    requests = questions.map do |question|
      choices = question['choices'].split(',').map(&:strip)
      correct_answer = question['correct_answer'].strip

      unless choices.include?(correct_answer)
        Rails.logger.debug "Correct answer '#{correct_answer}' is not among the provided choices for question '#{question['text']}'. Choices: #{choices.inspect}"
        raise "Correct answer '#{correct_answer}' is not among the provided choices for question '#{question['text']}'"
      end

      {
        create_item: {
          item: {
            title: question['text'],
            question_item: {
              question: {
                required: true,
                grading: {
                  point_value: 2,
                  correct_answers: {
                    answers: [{ value: correct_answer }]
                  },
                  when_right: { text: "You got it!" },
                  when_wrong: { text: "Sorry, that's wrong" }
                },
                choice_question: {
                  type: map_question_type(question['type']),
                  options: choices.map { |choice| { value: choice } }
                }
              }
            }
          },
          location: {
            index: 0
          }
        }
      }
    end

    Rails.logger.debug "Batch update requests: #{requests.inspect}"

    batch_update_request = Google::Apis::FormsV1::BatchUpdateFormRequest.new(
      requests: requests
    )
    @service.batch_update_form(form_id, batch_update_request)
  end

  def make_form_public(form_id)
    permission = {
      role: 'reader',
      type: 'anyone'
    }
    DriveService.new.create_permission(form_id, permission)
  end

  def authorize
    scope = 'https://www.googleapis.com/auth/forms.body'
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('config/credentials/google_forms.json'),
      scope: scope
    )
    authorizer.fetch_access_token!
    authorizer
  end

  def map_question_type(type)
    case type
    when 'multiple_choice'
      'RADIO'
    when 'checkbox'
      'CHECKBOX'
    when 'dropdown'
      'DROP_DOWN'
    else
      'RADIO' # Default to RADIO if the type is not recognized
    end
  end
end
