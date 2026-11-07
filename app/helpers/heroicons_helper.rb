# frozen_string_literal: true

module HeroiconsHelper
  ICON_PATHS = {
    arrow_down: {
      d: 'M19.5 13.5 12 21m0 0-7.5-7.5M12 21V3',
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    arrow_path: { d: 'M20 7a9 9 0 0 0-15-2L2 8m0-5v5h5M4 17a9 9 0 0 0 15 2l3-3m0 5v-5h-5' },
    arrow_up: {
      d: 'M4.5 10.5 12 3m0 0 7.5 7.5M12 3v18',
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    calendar_days: { d: 'M8 2v4m8-4v4M3 10h18M3 4h18v18H3ZM7 14h2m3 0h2m3 0h1M7 18h2m3 0h2' },
    check_circle: {
      d: 'M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12Zm13.36-1.814a.75.75 0 1 0-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 0 0-1.06 1.06l2.25 2.25a.75.75 0 0 0 1.14-.094l3.75-5.25Z', # rubocop:disable Layout/LineLength
      fill_rule: 'evenodd',
      clip_rule: 'evenodd',
    },
    clock: { d: 'M12 8v4l3 2m6-2a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z' },
    clipboard_document_check: {
      d: 'M11.35 3.836c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m8.9-4.414c.376.023.75.05 1.124.08 1.131.094 1.976 1.057 1.976 2.192V16.5A2.25 2.25 0 0 1 18 18.75h-2.25m-7.5-10.5H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V18.75m-7.5-10.5h6.375c.621 0 1.125.504 1.125 1.125v9.375m-8.25-3 1.5 1.5 3-3.75', # rubocop:disable Layout/LineLength
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    document_plus: {
      d: 'M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m3.75 9v6m3-3H9m1.5-12H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z', # rubocop:disable Layout/LineLength
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    envelope: {
      d: 'M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75', # rubocop:disable Layout/LineLength
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    exclamation_triangle: { d: 'M12 3 2 21h20L12 3ZM12 9v5m0 3h.01',
                            stroke_linecap: 'round', stroke_linejoin: 'round' },
    eye: {
      d: 'M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.964-7.178Z M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z', # rubocop:disable Layout/LineLength
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    information_circle: {
      d: 'm11.25 11.25.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9-3.75h.008v.008H12V8.25Z', # rubocop:disable Layout/LineLength
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    lock_closed: {
      d: 'M7.5 10.5V6a4.5 4.5 0 0 1 9 0v4.5M5.25 10.5h13.5V21H5.25Z',
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    magnifying_glass: {
      d: 'm21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z',
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    no_symbol: {
      d: 'M18.364 18.364A9 9 0 0 0 5.636 5.636m12.728 12.728A9 9 0 0 1 5.636 5.636m12.728 12.728L5.636 5.636',
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    pencil_square: {
      d: 'm16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0 1 15.75 21H5.25A2.25 2.25 0 0 1 3 18.75V8.25A2.25 2.25 0 0 1 5.25 6H10', # rubocop:disable Layout/LineLength
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    trash: {
      d: 'm14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673A2.25 2.25 0 0 1 15.916 21H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0', # rubocop:disable Layout/LineLength
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    user: {
      d: 'M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z', # rubocop:disable Layout/LineLength
      stroke_linecap: 'round',
      stroke_linejoin: 'round',
    },
    x_mark: { d: 'M6 18 18 6M6 6l12 12', stroke_linecap: 'round', stroke_linejoin: 'round' },
  }.freeze

  def heroicon(name, options = {})
    css_class = ['heroicon', options.delete(:class)].compact.join(' ')
    title = options.delete(:title)
    label = options.delete(:aria_label) || title
    icon_options = {
      class: css_class,
      fill: 'none',
      viewBox: '0 0 24 24',
      stroke_width: 1.5,
      stroke: 'currentColor',
      aria: { hidden: label.blank?, label: label.presence },
      role: label.present? ? 'img' : nil,
    }.merge(options)

    tag.svg(**icon_options.compact) do
      safe_join([title_tag(title), tag.path(**ICON_PATHS.fetch(name))])
    end
  end

  private

  def title_tag(title)
    return ''.html_safe if title.blank?

    tag.title(title)
  end
end
