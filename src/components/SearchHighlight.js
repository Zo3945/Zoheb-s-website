import React from 'react';

function SearchHighlight({ text, query }) {
  if (!query || !query.trim()) return <span>{text}</span>;
  const regex = new RegExp(`(${query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi');
  const parts = text.split(regex);
  return (
    <span>
      {parts.map((part, i) =>
        regex.test(part)
          ? <mark key={i} className="search-highlight">{part}</mark>
          : <span key={i}>{part}</span>
      )}
    </span>
  );
}

export default SearchHighlight;
