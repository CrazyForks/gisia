require 'rails_helper'

RSpec.describe 'Project Branch Selection', type: :system, js: true do
  let_it_be(:user) { create(:user) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  let(:branch_fixture) { YAML.load_file(File.join(__dir__, '../../fixtures/branch_files.yml')) }

  before do
    gisia_sign_in(user)

    allow_any_instance_of(Repository).to receive(:branch_names).and_return(['main', 'new-feature', 'develop'])

    allow_any_instance_of(Repository).to receive(:commit) do |instance, ref|
      double(id: "commit#{ref}", short_id: ref[0..3])
    end

    allow_any_instance_of(Repository).to receive(:tree) do |instance, ref, path = nil, **opts|
      entries = branch_fixture[ref]['files'].map do |file|
        double(name: file['name'], type: file['type'].to_sym)
      end
      double(entries: entries)
    end

    allow_any_instance_of(::Gitlab::TreeSummary).to receive(:fetch_logs) do |instance|
      ref = instance.commit.id.sub('commit', '')
      branch_data = branch_fixture[ref] || {}
      logs = (branch_data['logs'] || []).map do |log|
        {
          'file_name' => log['file_name'],
          'commit' => {
            'id' => "commit#{log['file_name']}",
            'short_id' => log['file_name'][0..6],
            'message' => "Commit for #{log['file_name']}",
            'committed_date' => Time.parse(log['committed_date'])
          },
          'commit_path' => "/commit/#{log['file_name']}",
          'commit_title_html' => "<p>Commit for #{log['file_name']}</p>"
        }
      end
      [logs, nil]
    end
  end

  describe 'branch dropdown selector' do
    it 'displays available branches in dropdown' do
      visit "/#{project.namespace.full_path}/-/tree/main"

      branch_select = find('select[name="ref"]')
      expect(branch_select).to have_content('main')
      expect(branch_select).to have_content('new-feature')
      expect(branch_select).to have_content('develop')
    end

    it 'shows the current branch as selected' do
      visit "/#{project.namespace.full_path}/-/tree/main"

      branch_select = find('select[name="ref"]')
      expect(branch_select.value).to eq('main')
    end
  end

  describe 'changing branch' do
    it 'navigates to the selected branch' do
      visit "/#{project.namespace.full_path}/-/tree/main"

      expect(page).to have_current_path("/#{project.namespace.full_path}/-/tree/main")

      branch_select = find('select[name="ref"]')
      branch_select.select('new-feature')

      expect(page).to have_current_path("/#{project.namespace.full_path}/-/tree/new-feature")
    end

    it 'updates the file list when branch is changed' do
      visit "/#{project.namespace.full_path}/-/tree/main"

      expect(page).to have_content('file-main-1.txt')
      expect(page).to have_content('file-main-2.txt')

      branch_select = find('select[name="ref"]')
      branch_select.select('new-feature')

      expect(page).not_to have_content('file-main-1.txt')
      expect(page).to have_content('file-feature-1.txt')
      expect(page).to have_content('file-feature-2.txt')
    end

    it 'displays the correct branch as selected after navigation' do
      visit "/#{project.namespace.full_path}/-/tree/main"

      branch_select = find('select[name="ref"]')
      branch_select.select('develop')

      expect(page).to have_current_path("/#{project.namespace.full_path}/-/tree/develop")

      new_branch_select = find('select[name="ref"]')
      expect(new_branch_select.value).to eq('develop')
      expect(page).to have_content('file-develop-1.txt')
    end
  end

end
